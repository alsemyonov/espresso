require 'espresso'

module Espresso
  module Controller
    extend Espresso::Concern

    module ClassMethods
    end

    module InstanceMethods
    end
  end
end

if defined?(InheritedResources)
  require 'espresso/controller/inherited_resources'
end
