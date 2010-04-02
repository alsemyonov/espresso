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
        manage_columns.inject('') do |result, column_name|
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
                      :colspan => manage_columns.size))
        if collection?
          result << content_tag(:tr,
                      content_tag(:th,
                        link_to_new,
                        :colspan => manage_columns.size))
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
        manage_columns.inject('') do |result, column_name|
          result << content_tag(:td) do
            if resource_class.name_field.to_sym == column_name
              link_to(resource, edit_resource_path(resource))
            else
              value = resource.send(column_name)
              case value
              when DateTime, Time
                content_tag(:time,
                            l(value, :format => :long),
                            :time => value.xmlschema)
              when Date
                value = value.to_date
                content_tag(:time,
                            l(value, :format => :long),
                            :time => value.xmlschema)
              else
                value.to_s
              end
            end
          end
          result
        end
      end
    end

    def manage_columns
      @manage_columns ||= if resource_class.respond_to?(:manage_columns) &&
                              resource_class.manage_columns.any?
                            resource_class.manage_columns
                          else
                            resource_class.columns.collect do |column|
                              column.name.to_sym
                            end
                          end
    end
  end
end
