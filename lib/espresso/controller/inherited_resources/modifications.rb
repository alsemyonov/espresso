require 'espresso/controller/inherited_resources'

module Espresso
  module Controller
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
          get_collection_ivar || set_collection_ivar(end_of_association_chain.espresso_collection(params))
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
