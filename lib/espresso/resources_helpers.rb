module Espresso
  module ResourcesHelpers
    def self.included(base)
      super
      base.send(:helper_method, :resource?, :collection?)
    end

    # Does the action or view have a resource
    # @return [Boolean] having a resource
    def resource?
      resource
    rescue
      false
    end

    # Does the action or view have a collection of objects
    # @return [Boolean] having a collection
    def collection?
      collection
    rescue
      false
    end
  end
end
