require 'espresso'
require 'active_support/core_ext/module'

module Espresso
  module View
    extend Espresso::Concern

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
                    options.merge(:time => time.xmlschema))
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
                   resource_class.name
                 else
                   controller_name.camelize
                 end
               when 'new'
                 "#{t('espresso.navigation.new', :default => 'New')} #{(resource? ? resource_class : controller_name.classify.constantize).human_name}"
               when 'edit'
                 "#{t('espresso.navigation.edit', :default => 'Edit')} #{(resource? ? resource_class : controller_name.classify.constantize).human_name}"
               else
                 t("navigation.#{controller_name}.#{view_name}")
               end
        %(<span class="translation_missing">#{text}</span>)
      end

      def page_title(title = nil, strip = false)
        @page_title = if title
                        title
                      elsif @page_title
                        @page_title
                      else
                        default = if !Rails.env.development?
                                    default_page_title
                                  else
                                    nil
                                  end

                        rsrc = if resource?
                                 if resource.new_record?
                                   resource_class.human_name
                                 else
                                   link_to(resource, resource_path)
                                 end
                               else
                                 nil
                               end

                        t("navigation.#{controller_name}.#{view_name}",
                          :default => default,
                          :resource => rsrc
                         )
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
      def navigation_list(menu)
        ''.tap do |result|
          menu.each do |item|
            path = "/#{item}"
            uri = request.request_uri
            title = t("navigation.#{item}.index", :default => item.to_s.camelize)
            result << content_tag(:li, :class => uri.starts_with?(path) ? 'selected' : nil) do
              link_to_unless_current(title, path) {
                content_tag(:strong, title)
              }
            end
          end
        end
      end

      def paginated_list(collection_name, options = {})
        collection = options.delete(:collection) do
          instance_variable_get("@#{collection_name}")
        end
        prefix = options.delete(:prefix)
        prefix = prefix ? " b-list_#{prefix}_#{collection_name}" : nil
        start = (collection.respond_to?(:offset) ? collection.offset : 0) + 1
        ''.tap do |result|
          result << content_tag(:ol,
                                render(collection),
                                :class => "b-list b-list_#{collection_name}#{prefix}",
                                :start => start)
          if collection.respond_to?(:total_pages)
            result << (will_paginate(collection, options) || '')
          end
        end
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
