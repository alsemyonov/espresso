require 'searchlogic'
require 'will_paginate'

module Espresso
  # @author Alexander Semyonov
  module Model
    unloadable

    def self.included(model)
      super
      model.class_eval do
        extend ClassMethods
        class_inheritable_accessor :model_attrs, :name_field
        self.model_attrs = []
        self.name_field = :name
      end
    end

    # String representation of model, based on Model’s name_field
    def to_s
      send(self.class.name_field).to_s
    end

    # Model’s classes, based on Model.model_attrs
    def model_class
      main_class = "#{::Espresso::MODEL_PREFIX}-#{self.class.name.underscore}"
      classes = [main_class] +
      self.class.model_attrs.inject([]) do |collection, attribute|
                     if send("#{attribute}?")
                       collection << " #{main_class}_#{attribute}"
                     end
                     collection
                   end
      classes.join(' ')
    end

    module ClassMethods
      # Paginates search results
      #
      # @param [Integer] page number of results’ page
      # @param [Hash] query searchlogic fields (proc’ed named scopes’ names with values)
      # @param [String] simple_query params for simple «LIKE '%something%'» searches (e.g. /people?q=Alexander)
      # @return [Array] searchlogic object and collection of results
      #
      # @todo Add an options to paginating
      def paginate_found(page = nil, query = {}, simple_query = nil)
        query ||= {}
        query.merge!(self.parse_simple_query(simple_query)) if simple_query
        @search = search(query)
        @results = @search.paginate(:page => page)
        [@search, @results]
      end
      alias_method :search_results, :paginate_found

      # Make searchlogic query from simple query option
      # Needed to be reimplemented in subclasses
      #
      # @param [String] simple query string
      # @return [Hash] searchlogic query
      def parse_simple_query(query)
        {:"#{name_field}_like" => query}
      end

      # Make a slug from object’s NameField
      # @param [ActiveRecord::Base] object, which slug is making
      # @return [String] slug
      def make_slug(object)
        object.send(name_field).parameterize
      end
    end
  end
end
