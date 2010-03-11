require 'will_paginate/view_helpers'

module Espresso
  module ActionView
    module Navigation
      VIEW_PLACEHOLDERS = {
        'create' => 'new',
        'update' => 'edit'
      }

      # Finds apropriate view name
      def view_name
        unless @view_name
          action_name = controller.action_name
          @view_name = VIEW_PLACEHOLDERS[action_name] || action_name
        end
        @view_name
      end

      def resource?
        resource
      rescue
        false
      end

      def collection?
        collection
      rescue
        false
      end

      # Make default page title, based on controller and action
      def default_page_title
        text = case view_name
               when 'index'
                 controller_name.camelize
               when 'new'
                 "#{t('espresso.navigation.new', :default => 'New')} #{controller_name.classify.constantize.human_name}"
               when 'edit'
                 "#{t('espresso.navigation.edit', :default => 'Editing')} #{controller_name.classify.constantize.human_name}"
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
                        default = if Rails.env.production?
                                    default_page_title
                                  else
                                    nil
                                  end

                        rsrc  = if resource?
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
        strip_tags([page_title, default].compact.join(separator))
      end

      def navigation_list(menu)
        returning '' do |result|
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

      include WillPaginate::ViewHelpers
      def will_paginate_with_i18n(collection, options = {})
        will_paginate_without_i18n(collection,
                                   options.merge({
          :class => 'b-pagination',
          :previous_label => t('espresso.navigation.previous', :default => '← Previous'),
          :next_label =>     t('espresso.navigation.next', :default => 'Next →')}))
      end
      alias_method_chain :will_paginate, :i18n
    end
  end
end
