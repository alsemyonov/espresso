require 'inherited_resources'

module Espresso
  class ObjectsController < InheritedResources::Base
    unloadable

    # Same as default InheritedResources::Base#new, but render 'edit' view,
    # other than 'new'
    def new
      new! do |format|
        format.html { render 'edit' }
      end
    end

    # Same as default InheritedResources::Base#create, but render 'edit' view,
    # other than 'new'
    def create
      create! do |success, failure|
        failure.html { render 'edit' }
      end
    end

  protected

    # Find collection of objects with pagination.
    # Also made Searchlogic object @search
    #
    # @return [WillPaginate::Collection] collection of objects
    def collection
      unless (result = get_collection_ivar).present?
        @search, result = end_of_association_chain.paginate_found(params[:page], params[:query], params[:q])
        set_collection_ivar(result)
      end
      result
    end

    # Build interpolation options for flash messages
    def interpolation_options
      { :resource_title => resource.to_s }
    end
  end
end
