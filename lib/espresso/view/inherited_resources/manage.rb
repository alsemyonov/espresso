require 'espresso/view'

module Espresso::View
  module InstanceMethods
    def manage_list
      content_tag(:table,
                  :class => 'b-espresso-collection',
                  :cellpadding => 0,
                  :cellspacing => 0) do
        content_tag(:thead, manage_list_header) +
          content_tag(:tfoot, manage_list_footer) +
          content_tag(:tbody, manage_list_collection)
      end
    end

    def manage_list_header
      content_tag(:tr) do
        manage_fields.inject('') do |result, column_name|
          result << content_tag(:th,
                                order(collection.search,
                                      :by => column_name,
                                      :as => resource_class.human_attribute_name(column_name)))
          result
        end
      end
    end

    def manage_list_footer
      ''.tap do |result|
        result << content_tag(:tr,
                    content_tag(:th,
                      will_paginate(collection),
                      :colspan => manage_fields.size))
        if collection?
          result << content_tag(:tr,
                      content_tag(:th,
                        link_to_new,
                        :colspan => manage_fields.size))
        end
      end
    end

    def manage_list_collection
      collection.inject('') do |result, item|
        result << manage_list_item(item)
        result
      end
    end

    def manage_list_item(resource)
      content_tag(:tr) do
        manage_fields.inject('') do |result, column_name|
          result << content_tag(:td,
                                manage_column_representation(resource,
                                                             column_name),
                                :class => column_name)
          result
        end
      end
    end

    def manage_column_representation(object, column_name)
      if resource_class.name_field.to_sym == column_name
        link_to(object, edit_resource_path(object))
      elsif column_name == :created_at
        if object.created_at == object.updated_at
          time(object.created_at)
        else
          t('espresso.view.created_and_updated',
            :created => time(object.created_at),
            :updated => time(object.updated_at))
        end
      else
        association_name = column_name.to_s.gsub(/_id$/, '')
        humanized_name = "human_#{association_name}"

        # Finds appropriate values for associations and humanized fields
        value = if object.respond_to?(humanized_name)
                  object.send(humanized_name)
                elsif object.respond_to?(association_name)
                  object.send(association_name)
                else
                  object.send(column_name)
                end

        # Appropriate representations for some fields
        case value
        when DateTime, Time
          time(value)
        when Date
          date(value)
        when ::ActiveRecord::Base
          link_to(value, value)
        else
          if respond_to?(:manage_field_typecast)
            manage_field_typecast(value)
          else
            value.to_s
          end
        end
      end
    end

    def manage_fields
      @manage_fields ||= manage_options.fields
    end
  end
end
