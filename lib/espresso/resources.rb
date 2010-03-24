require 'inherited_resources'

module Espresso
  module Resources
    def self.resources(controller = nil)
      controller ||= self
      controller.inherit_resources
      controller.extend ClassMethods
      controller.send(:include, InstanceMethods)
    end

    def self.included(controller)
      resources(controller)
    end

    module ClassMethods
      # Adds ability to build feeds for resource’s collections.
      # By default adds Atom feed
      # @example Add Atom feed for #index
      #   has_feed :atom
      # @example Add Atom and RSS feed for #index
      #   has_feed :atom, :rss
      # @example Add Atom, Rss, and ITunes feed for #index, #list and #archive
      #   has_feed :atom, :rss, :itunes_feed, :only => [:index, :list, :archive]
      def has_feed(*args)
        options = args.extract_options!
        if options.empty?
          options[:only] = :index
        end

        class_inheritable_accessor :feed_formats
        self.feed_formats = args.empty? ? [:atom] : args
        self.feed_formats = self.feed_formats.map(&:to_sym)

        self.feed_formats.each do |format|
          respond_to format, options
        end

        include FeedScope
      end
    end

    module FeedScope
      def apply_scopes(target_object)
        if params[:format] && self.class.feed_formats.include?(params[:format].to_sym)
          target_object.for_feed
        else
          target_object
        end
      end
    end

    module InstanceMethods
    protected

      # Find collection of objects with pagination.
      # Also made Searchlogic object @search
      #
      # @return [WillPaginate::Collection] collection of objects
      def collection
        unless (result = get_collection_ivar).present?
          @search, result = end_of_association_chain.for_index.
                              search_results(params[:page],
                                             params[:query],
                                             params[:q])
          set_collection_ivar(result)
        end
        result
      end

      # Build interpolation options for flash messages
      def interpolation_options
        if resource?
          { :resource_title => resource.to_s }
        end
      end
    end
  end
end
