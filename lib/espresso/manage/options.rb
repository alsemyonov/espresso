require 'espresso/manage'

module Espresso::Manage
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
      @list_display = to_field_set(field_set)
    end

    def list_display_links
      list_display.links
    end

    def list_display_links=(fields)
      list_display.links = fields
    end
  end
end
