require 'espresso/view'

module Espresso::View
  module InstanceMethods
    def manage_column_representation(object, field)
      # Finds appropriate values for associations and humanized fields
      value = field.value_for(object)

      if field.name == :created_at
        value = if value == object.updated_at
                  time(value, :format => :compact)
                else
                  t('espresso.view.created_and_updated',
                    :created => time(value, :format => :compact),
                    :updated => time(object.updated_at, :format => :compact)).html_safe
                end
      end

      value = case value
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

      if field.link?
        link_to(value, edit_resource_path(object))
      else
        value
      end
    end
  end
end
