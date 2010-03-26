require 'active_support/core_ext/module'

module Espresso
  module View
    mattr_accessor :block_prefix
    self.block_prefix = 'b'

    # @private
    def self.included(base)
      base.extend ClassMethods
      base.send(:include, InstanceMethods)
    end

    module ClassMethods
      # Generic espresso block classes
      # @param [String, Symbol] main_class main block class
      # @param [Array] modifiers array of modifiers for main block class
      # @param [Hash] options another options
      # @option options [String] :type (Espresso::View.block_prefix) type of the block
      def espresso_block_classes(main_class, modifiers = [], options = {})
        options ||= {}
        options[:type] ||= Espresso::View.block_prefix

        main_class = "#{options[:type]}-#{main_class}"
        [main_class].tap do |classes|
          modifiers.each do |modifier|
            classes << "#{main_class}_#{modifier}"
          end
        end.join(' ')
      end
    end

    module InstanceMethods
      # Model‘s classes, based on Model.model_modifiers
      # @param [ActiveRecord::Base] model model to build classes from
      def model_classes(model)
        klass = model.class
        main_class = klass.name.underscore.gsub(/(_|\/)/, '-')
        modifiers = if klass.respond_to?(:model_modifiers)
                      klass.model_modifiers.find_all do |modifier|
                        method = "#{modifier}?"
                        model.respond_to?(method) && model.send(method)
                      end
                    else
                      []
                    end
        self.class.espresso_block_classes(main_class,
                                          modifiers)
      end
    end
  end
end
