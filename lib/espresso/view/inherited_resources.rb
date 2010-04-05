require 'espresso/view'
require 'inherited_resources'

module Espresso
  module View
    module InstanceMethods
      def link_to_new(klass=nil, path=nil)
        klass ||= resource_class
        klass_underscored = klass.name.underscore
        path ||= if klass == resource_class
                   new_resource_path
                 else
                   [:new, klass_underscored]
                 end
        link_to(t("helpers.action.#{klass_underscored}.new",
                  :resource_class => klass.human_name,
                  :default => [:'helpers.action.new', 'Add']),
                path,
                :class => Espresso::View.block_classes('action', %w(new)))
      rescue
      end

      def link_to_show(object=nil)
        object ||= resource
        link_to(t("helpers.action.#{object.class.name.underscore}.show",
                  :resource => object.to_s,
                  :default => [:'helpers.action.show', object.to_s]),
                object,
                :class => Espresso::View.block_classes('action', %w(show)))
      rescue
      end

      def link_to_edit(object=nil, path=nil)
        object ||= resource
        path ||= if object == resource
                   edit_resource_path
                 else
                   [:edit, object]
                 end
        link_to(t("helpers.action.#{object.class.name.underscore}.edit",
                  :resource => object.to_s,
                  :default => [:'helpers.action.edit', 'Edit']),
                path,
                :class => Espresso::View.block_classes('action', %w(edit)))
      rescue
      end

      def link_to_destroy(object=nil, path=nil)
        object ||= resource
        path ||= if object == resource
                   resource_path
                 else
                   object
                 end
        class_underscored = object.class.name.underscore
        link_to(t("helpers.action.#{class_underscored}.edit",
                  :resource => object.to_s,
                  :default => [:'helpers.action.destroy', 'Destroy']),
                path,
                :class => Espresso::View.block_classes('action', %w(destroy)),
                :method => :delete,
                :confirm => t("helpers.action.#{class_underscored}.confirm_destroy",
                              :default => [:'helpers.action.confirm_destroy', 'are you sure?']))
      end

      def link_to_index
        link_to(t("navigation.#{controller_name}.index",
                  :default => [:'helpers.action.index', '&larr; Back']),
                    collection_path,
                    :class => 'b-action b-action_index')
      rescue
      end

      def resource_breadcrumbs(options = {})
        content_tag(:ol, :class => 'b-hlist b-hlist_arrow') do
          breadcrumbs = [].tap do |result|
            if resource?
              result << link_to_index
              if action_name != 'show'
                result << link_to_show
              end
            end
          end
          concat debug(breadcrumbs)
          breadcrumbs.map do |link|
            content_tag(:li, link)
          end.join
        end
      end
    end
  end
end
