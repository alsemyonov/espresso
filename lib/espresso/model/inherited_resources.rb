require 'espresso/model'
require 'espresso/collection'

module Espresso
  module Model
    # Extends Espresso::Model with scopes #for_collection and #for_feed
    def self.included_with_inherited_resources(base)
      included_without_inherited_resources(base)
      base.class_eval do
        named_scope :for_collection, :conditions => '1 = 1'
        named_scope :for_feed, :order => 'created_at DESC'
      end
    end
    class << self
      alias_method_chain :included, :inherited_resources
    end

    module ClassMethods
      # Collection of resources, found by params
      # @param [Hash] options options for ActiveRecord::Base#find
      # @return [Espresso::Collection, Array] collection of resources
      def collection(options = {})
        Espresso::Collection.new(self.for_collection, params)
      end
    end
  end
end
