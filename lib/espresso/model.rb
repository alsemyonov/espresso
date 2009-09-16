require 'searchlogic'

module Espresso
  # @author Alexander Semyonov
  module Model
    def self.included(model)
      model.extend ClassMethods
      model.send :include, InstanceMethods
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

      # Make searchlogic query from simple query option
      # Needed to be reimplemented in subclasses
      #
      # @param [String] simple query string
      # @return [Hash] searchlogic query
      def parse_simple_query(query)
        {:"#{name_field}_like" => query}
      end

      # «NameField» is a main field, used to represent model in to_s method and in simple queries
      # @param [Symbol, String] new_name_field new field name
      # @return [Symbol] field name
      def name_field
        :name
      end

      # Make a slug from object’s NameField
      # @param [ActiveRecord::Base] object, which slug is making
      # @return [String] slug
      def make_slug(object)
        object.send(name_field).parameterize
      end
    end

    module InstanceMethods
      def to_s
        send(self.class.name_field).to_s
      end

    protected
    end
  end
end
