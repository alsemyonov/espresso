require 'espresso'
require 'active_support/ordered_hash'

module Espresso
  module Manage
    class Field
      attr_accessor :name, :options

      def self.to_field(field)
        if field.is_a?(Field)
          field
        else
          Field.new(*Array(field))
        end
      end

      def initialize(name, options = {})
        self.name, self.options = name.to_sym, options
      end

      def real_options
        options.inject({}) do |result, (name, value)|
          result[name] = case value
                         when Proc
                           value.call
                         else
                           value
                         end
          result
        end
      end

      def to_input
        [name, real_options]
      end
    end

    class FieldSet < Array
      attr_accessor :options

      def self.to_field_set(field_set)
        if field_set.is_a?(Fieldset)
          field_set
        else
          FieldSet.new(*Array(field_set))
        end
      end

      def initialize(fields, options = {})
        replace(fields.map) do |field|
          Field.to_field(field)
        end
        self.options = options
      end

      def name
        options[:name]
      end
    end

    class BaseOptions
      attr_accessor :model_class, :main_field,
        :fields, :field_sets,
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
      end

      def model_class=(klass)
        if klass
          @model_class = klass
          @main_field = model_class.name_field.to_sym
        end
      end

      def fields
        @fields ||= FieldSet.new(default_fields)
      end

      def fields=(new_fields)
        @fields = FieldSet.new(new_fields)
      end

      def exclude(*args)
        self.fields -= args
      end

      def fields?
        fields && fields.any?
      end

      def field_sets
        unless @field_sets
          @field_sets = []
          @field_sets << self.fields
        end
        @field_sets
      end

      def field_sets?
        field_sets && field_sets.any?
      end

    protected
      def default_fields
        fields = if model_class.respond_to?(:manage_fields) &&
                    model_class.manage_fields.any?
                   model_class.manage_fields
                 else
                   model_class.columns.collect do |column|
                     column.name.to_sym
                   end - [:id, :updated_at, :type]
                 end
        fields = [model_class.name_field] + (fields - [model_class.name_field])
        fields
      end
    end

    class Options < BaseOptions
      attr_accessor :list_display, :list_display_links, :list_filter,
        :list_select_related, :list_per_page, :list_editable,
        :search_fields, :date_hierarchy, :save_as, :save_on_top,
        :ordering, :inlines

      def initialize(model_class = nil, options = {})
        super
        self.list_display = [self.model_class.name_field]
        self.list_display_links = []
        self.list_filter = []
        self.list_select_related = false
        self.list_per_page = 100
        self.list_editable = []
        self.search_fields = []
        self.date_hierarchy = nil
        self.save_as = false
        self.save_on_top = false
        self.ordering = nil
        self.inlines = []
      end
    end
  end
end
