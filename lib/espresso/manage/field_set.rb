require 'espresso/manage'

module Espresso::Manage
  class FieldSet < Array
    attr_accessor :manage_options, :options

    def initialize(manage_options, *fields)
      self.manage_options = manage_options
      self.options = fields.extract_options!

      fields = fields.map do |field|
        to_field(field)
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
        detected = detect do |field|
                     field.name == field_name
                   end
        if detected
          detected
        else
          new_field = Field.new(manage_options, field_name)
          self << new_field
          new_field
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

  protected
    def to_field(field)
      if field.is_a?(Field)
        field
      else
        name, options = field
        manage_options.fields[name.to_sym] || Field.new(manage_options, name, options)
      end
    end
  end
end
