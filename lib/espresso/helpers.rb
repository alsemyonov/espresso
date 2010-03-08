require 'will_paginate/view_helpers'

module Espresso
  module Helpers
    include WillPaginate::ViewHelpers

    def simple_search
      returning '' do |form|
        form << form_tag(url_for(:action => :index), :method => :get)
        form << content_tag(:table, :class => 'b-search') do
                  content_tag(:tr) do
                    returning '' do |result|
                      result << content_tag(:td,
                                            content_tag(:div, text_field_tag(:q, params[:q], :type => 'search'), :class => 'b-input'),
                                            :class => 'input')
                      result << content_tag(:td,
                                            submit_tag(t('krasivotokak.espresso.find', :default => 'Find!'), :class => 'submit'),
                                            :class => 'button')
                    end
                  end
                end
        form << yield if block_given?
        form << '</form>'
      end
    end

    def will_paginate_with_i18n(collection, options = {})
      will_paginate_without_i18n(collection,
                                 options.merge({
        :class => 'b-pagination',
        :previous_label => t('krasivotokak.espresso.previous', :default => '← Previous'),
        :next_label =>     t('krasivotokak.espresso.next', :default => 'Next →')}))
    end
    alias_method_chain :will_paginate, :i18n

    def body_modifiers
      {:class => "m-#{controller_name} m-#{controller_name}_#{action_name}"}
    end

    def scope_filter(scopes)
      items = scopes.inject([]) do |list, scope|
        list << link_to_unless_current(t(".#{scope}"), collection_path(scope => true))
        list
      end

      content_tag(:div, :class => 'b-scope-filter') do
        content_tag(:ul, :class => 'b-hlist b-hlist_vline') do
                                "<li>#{items.join('<li></li>')}</li>"
        end
      end
    end

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
