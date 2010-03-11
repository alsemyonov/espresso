module Espresso
  module ActionView
    module Resources
      def link_to_new(klass=nil, path=nil)
        klass ||= resource_class
        klass_underscored = klass.name.underscore
        path ||= klass == resource_class ? new_resource_path : [:new, klass_underscored]
        link_to(t("helpers.action.#{klass_underscored}.new",
                  :default => [:'helpers.action.new', 'Добавить']),
                path,
                :class => 'b-action b-action_new')
      rescue
      end

      def link_to_show(object=nil)
        object ||= resource
        link_to(t("helpers.action.#{object.class.name.underscore}.show",
                  :default => [:'helpers.action.show', object.to_s]),
                object,
                :class => 'b-action b-action_show')
      rescue
      end

      def link_to_edit(object=nil, path=nil)
        object ||= resource
        path ||= object == resource ? edit_resource_path : [:edit, object]
        link_to(t("helpers.action.#{object.class.name.underscore}.edit",
                  :default => [:'helpers.action.edit', 'Редактировать']),
                path,
                :class => 'b-action b-action_edit')
      rescue
      end

      def link_to_destroy(object=nil, path=nil)
        object ||= resource
        path ||= object == resource ? resource_path : object
        link_to(t("helpers.action.#{object.class.name.underscore}.edit",
                  :default => [:'helpers.action.destroy', 'Удалить']),
                path,
                :class => 'b-action b-action_destroy',
                :method => :delete,
                :confirm => 'Вы уверены?')
      end

      def link_to_index
        link_to(t("helpers.action.#{controller_name.singularize}.index",
                  :default => [:'helpers.action.index', '&larr; К списку']),
                collection_path,
                :class => 'b-action b-action_index'
               )
      rescue
      end
    end
  end
end
