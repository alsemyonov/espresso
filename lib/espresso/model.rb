module Espresso
  module Model
    def self.included(model)
      model.extend ClassMethods
      model.class_eval do
        include InstanceMethods

        attr_accessor :name_field
        self.name_field = :name
      end
    end

    module ClassMethods
      def paginate_found(page = nil, query = nil, simple_query = nil)
        query ||= {}
        query.merge(parse_simple_query(simple_query)) if simple_query.present?
        @search = search(query)
        @results = @search.paginate(:page => page)
        [@search, @results]
      end

      def parse_simple_query(query)
        {:"#{name_field}_like" => query}
      end

      def name_field(new_name_field = nil)
        if new_name_field.present?
          @@name_field = new_name_field
        end
        @@name_field
      end

      def make_slug(object)
        object.send(name_field).parameterize
      end
    end

    module InstanceMethods
      def to_s
        send(@@name_field).to_s
      end

    protected
    end
  end
end
