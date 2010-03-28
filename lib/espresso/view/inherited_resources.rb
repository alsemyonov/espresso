require 'espresso'
require 'inherited_resources'
require 'espresso/view'

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
                  :default => [:'helpers.action.new', 'Add']),
                path,
                :class => self.class.espresso_block_classes('action', %w(new)))
      rescue
      end
      def link_to_show(object=nil)
        object ||= resource
        link_to(t("helpers.action.#{object.class.name.underscore}.show",
                  :default => [:'helpers.action.show', object.to_s]),
                object,
                :class => self.class.espresso_block_classes('action', %w(show))
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
                  :default => [:'helpers.action.edit', 'Edit']),
                path,
                :class => self.class.espresso_block_classes('action', %w(edit))
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
                  :default => [:'helpers.action.destroy', 'Destroy']),
                path,
                :class => self.class.espresso_block_classes('action', %w(destroy)),
                :method => :delete,
                :confirm => t("helpers.action.#{class_underscored}.confirm_destroy",
                              :default => [:'helpers.action.confirm_destroy', 'are you sure?']))
      end

      def link_to_index
        link_to(t("helpers.action.#{controller_name.singularize}.index",
                  :default => [:'helpers.action.index', '&larr; Back']),
                    collection_path,
                    :class => 'b-action b-action_index'
               )
      rescue
      end

    end
  end
end
