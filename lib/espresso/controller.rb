module Espresso
  module Controller
    def self.included(base)
      base.extend ClassMethods
      base.class_eval do
        include InstanceMethods
      end
    end

    module ClassMethods
    end

    module InstanceMethods
    end
  end
end
