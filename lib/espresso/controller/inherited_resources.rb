require 'espresso/controller'
require 'espresso/manage'
require 'inherited_resources'
require 'active_support/core_ext/class/inheritable_attributes'

module Espresso
  module Controller
    mattr_accessor :default_resources_options
    self.default_resources_options = {
      :enhance => true
    }

    included do
      helper_method :resource?, :collection?
    end

    autoload :InheritedResourcesModifications, 'espresso/controller/inherited_resources/modifications'
    autoload :InheritedResourcesManage, 'espresso/controller/inherited_resources/manage'

    module ClassMethods
      # Includes default CRUD actions in ActionController::Base using InheritedResources, enhance
      # @param [Hash] options options of resources
      # @option options :enhance (true) whether to enhance resource controller with Espresso-provided helpers or not
      def resources(options = {})
        options.reverse_merge!(Espresso::Controller.default_resources_options)

        ::InheritedResources::Base.inherit_resources(self)
        initialize_resources_class_accessors!
        create_resources_url_helpers!

        if options[:enhance]
          include Espresso::Controller::InheritedResourcesModifications
        end
      end

      def manage_resources(options = {})
        resources(options)

        class_inheritable_accessor :manage_options
        include Espresso::Controller::InheritedResourcesManage

        manage = Espresso::Manage::Options.new(resource_class)
        if block_given?
          yield(manage)
        end
        self.manage_options = manage

        helper_method :manage_options
      end
    end

    module InstanceMethods
    protected
      # Does the action or view have a resource
      # @return [Boolean] having a resource
      def resource?
        params.key?(:id) && resource
      rescue
        false
      end

      # Does the action or view have a collection of objects
      # @return [Boolean] Having a collection
      def collection?
        !params.key?(:id) && collection
      rescue
        false
      end
    end

  end
end
