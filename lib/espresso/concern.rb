require 'espresso'

module Espresso
  # Code extracted from ActiveSupport 3.0.0beta
  module Concern
    def self.extended(base)
      base.instance_variable_set('@_dependencies', [])
    end

    def append_features(base)
      if base.instance_variable_defined?('@_dependencies')
        base.instance_variable_get('@_dependencies') << self
        return false
      else
        return false if base < self
        @_dependencies.each { |dep| base.send(:include, dep) }
        super
        base.extend const_get('ClassMethods') if const_defined?('ClassMethods')
        base.send :include, const_get('InstanceMethods') if const_defined?('InstanceMethods')
        if instance_variable_defined?('@_included_blocks')
          @_included_blocks.each do |included_block|
            base.class_eval(&included_block)
          end
        end
      end
    end

    def included(base = nil, &block)
      if base.nil?
        @_included_blocks ||= []
        @_included_blocks << block
      else
        super
      end
    end
  end
end
