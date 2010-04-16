require 'espresso/manage'

module Espresso::Manage
  class FieldSet < Array
    attr_accessor :options

    def self.to_field_set(field_set)
      if field_set.is_a?(FieldSet)
        field_set
      else
        FieldSet.new(*Array(field_set))
      end
    end

    def initialize(*fields)
      self.options = fields.extract_options!

      fields = fields.map do |field|
        Field.to_field(field)
      end
      replace(fields)
    end

    def name
      options[:name]
    end

    def [](field_name)
      if field_name.is_a?(Numeric)
        super
      else
        detect do |field|
          field.name == field_name
        end
      end
    end

    def links
      @links ||= inject([]) do |result, field|
        result << field.name if field.link?
        result
      end
    end

    def links=(link_fields)
      link_fields = link_fields.map(&:to_sym)
      each do |field|
        field.link = link_fields.include?(field.name)
      end
    end
  end
end
