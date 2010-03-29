require 'espresso/model'
require 'espresso/collection'

module Espresso
  module Model
    included do
      named_scope :for_collection, :conditions => '1 = 1'
      named_scope :for_feed, :order => 'created_at DESC'
    end

    module ClassMethods
      # Collection of resources, found by params
      # @param [Hash] options options for ActiveRecord::Base#find
      # @return [Espresso::Collection, Array] collection of resources
      def collection(options = {})
        Espresso::Collection.new(self.for_collection, options)
      end
    end
  end
end
