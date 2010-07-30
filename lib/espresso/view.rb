require 'espresso'
require 'active_support/core_ext/module'

module Espresso
  module View
    extend Espresso::Concern

    autoload :FormBuilder, 'espresso/view/form_builder'

    mattr_accessor :block_prefix
    self.block_prefix = 'b'

    # Generic espresso block classes
    # @param [String, Symbol] main_class main block class
    # @param [Array] modifiers array of modifiers for main block class
    # @param [Hash] options another options
    # @option options [String] :type (Espresso::View.block_prefix) type of the block
    def self.block_classes(main_class, modifiers = [], options = {})
      options ||= {}
      options[:type] ||= Espresso::View.block_prefix

      main_class = "#{options[:type]}-#{main_class}"
      [main_class].tap do |classes|
        modifiers.each do |modifier|
          classes << "#{main_class}_#{modifier}"
        end
      end.join(' ')
    end

    module ClassMethods
    end

    module InstanceMethods
      VIEW_PLACEHOLDERS = {
        'create' => 'new',
        'update' => 'edit'
      }

      # Overwrites current url.
      # By default uses full path (with host), if it is not overwrited in options
      # @param [Hash] overwrites hash of params to overwrite
      # @param [Hash] options hash of options to url_for
      # @return [String] overwrited url
      def overwrite_url(overwrites, options = {})
        overwrites ||= {}
        options ||= {}
        options[:only_path] = false unless options.key?(:only_path)
        url_for({:overwrite_params => (overwrites || {})}.merge(options))
      end

      # Overwrites current path.
      # By default uses relative path (started with /), if it is not overwrited in options
      # @param [Hash] overwrites hash of params to overwrite
      # @param [Hash] options hash of options to url_for
      # @return [String] overwrited path
      def overwrite_path(overwrites, options = {})
        options ||= {}
        options[:only_path] = true unless options.key?(:only_path)
        overwrite_url(overwrites, options)
      end

      # Helper to write time in human- and machine-readable format
      # @param [Time, DateTime] time time to represent
      # @return [String] <time> tag with time representation
      def time(time, options = {})
        format = options.delete(:format) { :long }
        content_tag(:time,
                    l(time, :format => format),
                    options.merge(:datetime => time.xmlschema))
      end

      # Helper to write date in human- and machine-readable format
      # @param [Time, DateTime, Date] time_or_date time or date to represent
      # @return [String] <time> tag with time or date to represent
      def date(time_or_date, options = {})
        time(time_or_date.to_date, options)
      end



      # Model‘s classes, based on Model.model_modifiers
      # @param [ActiveRecord::Base] model model to build classes from
      def model_classes(model)
        klass = model.class
        main_class = klass.name.underscore.gsub(/(_|\/)/, '-')
        modifiers = if klass.respond_to?(:model_modifiers)
                      klass.model_modifiers.find_all do |modifier|
                        method = "#{modifier}?"
                        model.respond_to?(method) && model.send(method)
                      end
                    else
                      []
                    end
        Espresso::View.block_classes(main_class,
                                          modifiers)
      end

      # Finds apropriate view name
      # @return [String] current view name
      def view_name
        unless @view_name
          action_name = controller.action_name
          @view_name = VIEW_PLACEHOLDERS[action_name] || action_name
        end
        @view_name
      end

      # Makes default page title, based on controller and action
      # @return [String] default page title
      def default_page_title
        text = case view_name
               when 'index'
                 if collection?
                   resource_class.name.pluralize
                 else
                   controller_name.camelize
                 end
               when 'new'
                 "#{t('espresso.navigation.new', :default => 'New')} #{(resource? ? resource_class : controller_name.classify.constantize).model_name.human}"
               when 'edit'
                 "#{t('espresso.navigation.edit', :default => 'Edit')} #{(resource? ? resource_class : controller_name.classify.constantize).model_name.human}"
               else
                 if resource?
                   resource.to_s
                 else
                   "#{controller_name} — #{action_name}"
                 end
               end.html_safe
        %(<span class="translation_missing">#{text}</span>).html_safe
      end

      def page_title(title = nil, strip = false)
        @page_title = if title
                        title.to_s
                      elsif @page_title
                        @page_title
                      else
                        default = default_page_title

                        rsrc = if resource?
                                 if resource.new_record?
                                   resource_class.model_name.human
                                 else
                                   link_to(resource, resource_path)
                                 end
                               else
                                 nil
                               end

                        t("navigation.#{controller.controller_path.gsub(/\//, '.')}.#{view_name}",
                          :default => default,
                          :resource => rsrc
                         ).html_safe
                      end
        if strip
          strip_tags(@page_title)
        else
          @page_title
        end
      end

      def head_title(default = false, separator = ' | ')
        default ||= t('application.meta.title')
        [page_title(nil, true), default].compact.join(separator)
      end

      # Draws navigation list, using <li> with <a>
      # @param [Array<Symbol, String>] menu list of menu items (paths without /)
      # @return [String] Resulting menu without <ul> or <ol>
      def navigation_list(menu, prefix = nil)
        ''.tap do |result|
          menu.each do |item|
            path = url_for(:controller => prefix ? "#{prefix}/#{item}" : item, :only_path => true)
            uri = request.fullpath
            title = t(['navigation', prefix, item, 'index'].compact.join('.'),
                      :default => item.to_s.camelize)
            result << content_tag(:li, :class => uri.starts_with?(path) ? 'selected' : nil) do
              link_to_unless_current(title, path) {
                content_tag(:strong, title)
              }
            end
          end
        end.html_safe
      end

      def filter_links(filter)
        content_tag(:div, :class => 'b-filter') do
          content_tag(:span, "#{t('view.helpers.filter', :default => 'Filter')}: ") <<
          content_tag(:ul, :class => 'b-hlist b-hlist_space') do
            filter.inject(''.html_safe) do |result, link|
              result << content_tag(:li,
                                    link_to_unless_current(t(".#{link}",
                                                             :default => link.humanize),
                                                           {link => true},
                                                           :class => 'ajax'),
                                    :class => link)
            end
          end
        end
      end

      # Render view if present, otherwise fallback to standard view in Espresso
      # @param [String, Symbol] view_name name of a view template
      # @param [Hash, String] options options to render method
      # @option options [String, Symbol] :fallback (:espresso) fallback prefix or full path to fallback template
      def render_with_fallback(view_name, options = {})
        if options.is_a?(String)
          prefix, options = options, {}
        else
          options ||= {}
          prefix = options.delete(:fallback) { :espresso }
        end
        render(view_name, options)
      rescue ::ActionView::MissingTemplate
        view_name = if prefix.is_a?(Symbol)
                      "#{prefix}/#{view_name}"
                    else
                      prefix
                    end
        render(view_name, options)
      end

      # Set online statistics trackers
      # @param [Hash] options online statistics keys
      # @option options [Hash] :piwik Piwik code: id. site
      # @option options [String, Numeric] :metrika Yandex.Metrika code
      # @option options [String] :analytics, 
      def online_stats(options = {})
        static_includes = []
        dynamic_includes = ''
        noscript_includes = []
        initializers = []

        if piwik = options.delete(:piwik)
          static_includes   << "//#{piwik[:site]}/piwik.js"
          initializers      << "var piwikTracker=Piwik.getTracker('//#{piwik[:site]}/piwik.php',#{piwik[:id]});piwikTracker.trackPageView();piwikTracker.enableLinkTracking();"
          noscript_includes << "//#{piwik[:site]}/piwik.php?idsite=#{piwik[:id]}"
        end

        if metrika = options.delete(:metrika)
          static_includes   << '//mc.yandex.ru/resource/watch.js'
          initializers      << "var yaCounter#{metrika}=new Ya.Metrika(#{metrika});"
          noscript_includes << "//mc.yandex.ru/watch/#{metrika}"
        end

        if analytics = options.delete(:analytics)
          dynamic_includes << 'var gaJsHost=("https:"==document.location.protocol)?"https://ssl.":"http://www.";'
          dynamic_includes << 'document.write(unescape("%3Cscript src=\'"+gaJsHost+"google-analytics.com/ga.js\' type=\'text/javascript\'%3E%3C/script%3Ei"));'
          initializers     << "var pageTracker=_gat._getTracker('#{analytics}');pageTracker._trackPageview();"
        end

        ''.tap do |result|
          unless dynamic_includes.empty?
            result << javascript_tag(dynamic_includes)
          end
          result << javascript_include_tag(static_includes) unless static_includes.empty?
          unless initializers.empty?
            initializers = initializers.collect do |initializer|
                                                                                                                                            "try {#{initializer}} catch(e) {}"
            end.join("\n")
            result << javascript_tag(initializers)
          end

          unless noscript_includes.empty?
            includes = noscript_includes.collect do |noscript|
                                                                                                                                                      %(<img src="#{noscript}" style="border:0" alt="" />)
            end.join("\n")
            result << content_tag(:noscript,
                                  content_tag(:div,
                                              includes,
                                              :style => 'position: absolute'))
          end
        end
      end

      # Make body’s modifiers, based on controller_name and action_name
      def body_modifiers
        {:class => "m-#{controller_name} m-#{controller_name}_#{action_name}"}
      end

    end
  end
end

if defined?(WillPaginate)
  require 'espresso/view/will_paginate'
end

if defined?(InheritedResources)
  require 'espresso/view/inherited_resources'
end

if defined?(HasScope)
  require 'espresso/view/has_scope'
end

if defined?(Searchlogic)
  require 'espresso/view/searchlogic'
end

if defined?(Formtastic)
  require 'espresso/view/form_builder'
end
