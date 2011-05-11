require 'espresso/model'
require 'espresso/collection'
require 'inherited_resources'

module Espresso
  module Model
    included do
      alias for_collection scoped
      if respond_to?(:desc)
        scope :for_feed, desc(:created_at)
      else
        scope :for_feed, order('created_at DESC')
      end
    end

    module ClassMethods
      # Collection of resources, found by params
      # @param [Hash] options options for ActiveRecord::Base#find
      # @return [Espresso::Collection, Array] collection of resources
      def espresso_collection(options = {})
        Espresso::Collection.new(self.for_collection, options)
      end
    end
  end
end
