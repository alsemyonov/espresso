require 'espresso/controller'
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
    end

    module InstanceMethods
      # Does the action or view have a resource
      # @return [Boolean] having a resource
      def resource?
        resource
      rescue
        false
      end

      # Does the action or view have a collection of objects
      # @return [Boolean] Having a collection
      def collection?
        collection
      rescue
        false
      end
    end

    module InheritedResourcesModifications
      extend Espresso::Concern

      module ClassMethods
        # Adds ability to build feeds for resource’s collections.
        # By default adds Atom feed
        # @example Add Atom feed for #index
        #   has_feed :atom
        # @example Add Atom and RSS feed for #index
        #   has_feed :atom, :rss
        # @example Add Atom, Rss, and ITunes feed for #index, #list and #archive
        #   has_feed :atom, :rss, :itunesfeed, :only => [:index, :list, :archive]
        def has_feed(*args)
          require 'has_scope'

          options = args.extract_options!
          if options.empty?
            options[:only] = :index
          end

          class_inheritable_accessor(:feed_formats) unless respond_to?(:feed_formats)
          self.feed_formats = (args.empty? ? [:atom] : args).map(&:to_s)

          self.feed_formats.each do |format|
            respond_to format, options
          end

          include FeedScope
          has_scope(:for_feed, options.merge(:default => true,
                                             :type => :boolean,
                                             :if => :feed_scope_applicable?))
        end
      end

      module InstanceMethods
        # Find collection of resources, wrapped with Espresso::Collection
        # @return [Espresso::Collection] collection of resources
        def collection
          get_collection_ivar || set_collection_ivar(end_of_association_chain.collection(params))
        end

        # Build interpolation options for flash messages
        # @return [Hash, nil] hash of interpolation options if current action has a resource, nil otherwise
        def interpolation_options
          if resource?
            { :resource_title => resource.to_s }
          end
        end
      end

      module FeedScope
        # Does scope #for_feed applicable to current action?
        # @return [Boolean] if applicable
        def feed_scope_applicable?
          params[:format] && self.class.feed_formats.include?(params[:format].to_sym)
        end
      end
    end
  end
end
