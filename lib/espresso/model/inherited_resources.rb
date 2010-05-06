require 'espresso/model'
require 'espresso/collection'

module Espresso
  module Model
    included do
      if respond_to?(:scope) && respond_to?(:where)
        scope :for_collection, where('1 = 1')
        scope :for_feed, order('created_at DESC')
      elsif respond_to?(:named_scope)
        named_scope :for_collection, :conditions => '1 = 1'
        named_scope :for_feed, :order => 'created_at DESC'
      else
        extend DummyScopes
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

    module DummyScopes
      def for_collection
        self
      end

      def for_feed
        self
      end
    end
  end
end
