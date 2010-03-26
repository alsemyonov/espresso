require 'active_support/core_ext/class/inheritable_attributes'
require 'active_support/core_ext/string'

module Espresso
  module Model
    # @private
    def self.included(base) #:nodoc:
      base.extend ClassMethods
      base.class_eval do
        include InstanceMethods

        class_inheritable_accessor :name_field, :model_modifiers

        self.name_field = :name
        self.model_modifiers = []
      end
    end

    module ClassMethods
      # Make a slug from object‘s #name_field
      # @param [ActiveRecord::Base] model object, which slug is making
      # @return [String] slug made from model’s #name_field
      def make_slug(model)
        model.send(name_field).parameterize
      end
    end

    module InstanceMethods
      # String representation of model, based on Model’s #name_field
      def to_s
        send(self.class.name_field)
      end
    end
  end
end
