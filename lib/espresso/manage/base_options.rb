require 'espresso/manage'

module Espresso::Manage
  class BaseOptions
    STUFF_FIELDS = [:id, :updated_at, :type]

    attr_accessor :model_class, :main_field,
      :filter_vertical, :filter_horizontal,
      :radio_fields, :prepopulated_fields

    def initialize(model_class = nil, options = {})
      @fields = nil
      @field_sets = nil
      @filter_vertical = []
      @filter_horizontal = []
      @radio_fields = {}
      @prepopulated_fields = {}

      self.model_class = model_class
      self.main_field = model_class.name_field if model_class.respond_to?(:name_field)
      fields = model_class.field_names - STUFF_FIELDS - [main_field]
      @fields = FieldSet.new(self)
      ([main_field] + fields).each do |field_name|
        @fields << Field.new(self, field_name)
      end
      @fields[main_field].link!
    end

    def model_class=(klass)
      if klass
        @model_class = klass
        @main_field = model_class.name_field.to_sym
      end
    end

    def fields
      @fields
    end

    def fields=(new_fields)
      @fields = to_field_set(new_fields)
    end

    def exclude(*args)
      self.fields -= args
    end

    def fields?
      fields && fields.any?
    end

    def field_sets(auto = true)
      unless @field_sets
        @field_sets = []
        @field_sets << self.fields if auto
      end
      @field_sets
    end

    def field_sets=(sets)
      @field_sets = sets.map do |set|
        to_field_set(set)
      end
    end

    def field_sets?
      field_sets && field_sets.any?
    end

  protected
    def to_field_set(field_set)
      if field_set.is_a?(FieldSet)
        field_set
      else
        FieldSet.new(self, *Array(field_set))
      end
    end
  end
end
