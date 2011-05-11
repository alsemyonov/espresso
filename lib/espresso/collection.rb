require 'active_support/core_ext/class/attribute'

module Espresso
  self.extensions << :collection

  # Represents collection of resources.
  # Used in Espresso::Controller InheritedResources extension
  class Collection < Array
    class_attribute :per_page
    self.per_page = 30

    attr_accessor :base, :options, :collection, :search
    protected :base, :options, :collection

    # Initiates a collection of resources
    # @param [AtiveRecord::Base] base Base class having {Espresso::Model} included
    # @param [Hash] options options for building the collection
    # @option options [Number] :page current page number
    # @option options [Number] :per_page per-page limit
    # @option options [Hash] :search conditions for searching
    def initialize(base, options = {})
      @base, @options = base, options
      replace(collection)
    end

  protected
    # All resources in {#base}
    def collection
      @collection ||= base.all(@options)
    end

    # Proxy to {#collection} methods
    def method_missing(method_name, *args)
      collection.send(method_name, *args)
    end
  end
end

if defined? WillPaginate
  require 'espresso/collection/will_paginate'
end
