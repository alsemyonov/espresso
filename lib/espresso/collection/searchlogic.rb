require 'espresso/collection'
require 'searchlogic'

module Espresso
  class Collection
    # Use ActiveRecord::Base#searchlogic method to generate
    # base for finding the collection
    # @return [ActiveRecord::Base] ActiveRecord model scoped with searchlogic
    def base
      unless @search
        search_options = options.delete(:search) { {} }
        @search = @base.searchlogic(search_options)
      end
      @search
    end
  end
end
