require 'inherited_resources'

module Espresso
  class Resource < InheritedResources::Base
    unloadable

  protected

    # Find collection of objects with pagination.
    # Also made Searchlogic object @search
    #
    # @return [WillPaginate::Collection] collection of objects
    def collection
      unless (result = get_collection_ivar).present?
        @search, result = end_of_association_chain.search_results(params[:page], params[:query], params[:q])
        set_collection_ivar(result)
      end
      result
    end

    # Build interpolation options for flash messages
    def interpolation_options
      if resource
        { :resource_title => resource.to_s }
      end
    end
  end
end
