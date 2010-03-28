require 'espresso/collection'
require 'will_paginate/collection'

module Espresso
  class Collection
    # Finds collection by ActiveRecord::Base.paginate method
    # and options provided in {Espresso::Collection#initialize} method
    # @return [WillPaginate::Collection] single page of resources
    def collection
      unless @collection
        page     = options.delete(:page) { 1 }
        per_page = options.delete(:per_page) { Espresso::Collection.per_page }
        total    = options.delete(:total)
        @collection ||= base.paginate(page, per_page, total)
      end
      @collection
    end
  end
end
