require 'espresso'
require 'active_support/core_ext/class/inheritable_attributes'
require 'active_support/core_ext/string'

module Espresso
  module Model
    extend Espresso::Concern

    included do
      class_inheritable_accessor :name_field, :model_modifiers

      self.name_field = :name
      self.model_modifiers = []
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

if defined?(InheritedResources)
  require 'espresso/model/inherited_resources'
end
