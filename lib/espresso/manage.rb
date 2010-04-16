require 'espresso'
require 'active_support/ordered_hash'

module Espresso
  module Manage
    autoload :Field, 'espresso/manage/field'
    autoload :FieldSet, 'espresso/manage/field_set'

    class BaseOptions
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
      end

      def model_class=(klass)
        if klass
          @model_class = klass
          @main_field = model_class.name_field.to_sym
        end
      end

      def fields
        @fields ||= Espresso::Manage::FieldSet.new(*default_fields)
      end

      def fields=(new_fields)
        @fields = Espresso::Manage::FieldSet.to_field_set(new_fields)
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
          Rails.logger.warn(set.inspect)
          Espresso::Manage::FieldSet.to_field_set(set)
        end
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
      attr_accessor :list_filter,
        :list_select_related, :list_per_page, :list_editable,
        :search_fields, :date_hierarchy, :save_as, :save_on_top,
        :ordering, :inlines

      def initialize(model_class = nil, options = {})
        super
        @list_display = nil
        @list_filter = []
        @list_select_related = false
        @list_per_page = 100
        @list_editable = []
        @search_fields = []
        @date_hierarchy = nil
        @save_as = false
        @save_on_top = false
        @ordering = nil
        @inlines = []
      end

      def list_display
        @list_display ||= self.fields.tap do |fields|
          fields[main_field].link!
        end
      end

      def list_display=(field_set)
        @list_display = Espresso::Manage::FieldSet.to_field_set(field_set)
      end

      def list_display_links
        list_display.links
      end

      def list_display_links=(fields)
        list_display.links = fields
      end
    end
  end
end
