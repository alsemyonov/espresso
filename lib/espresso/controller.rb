module Espresso
  class Controller < InheritedResources::Base
    def new
      new! do |format|
        format.html { render 'edit' }
      end
    end

    def create
      create! do |success, failure|
        failure.html { render 'edit' }
      end
    end

  protected
    def collection
      unless (result = get_collection_ivar).present?
        @search, result = end_of_association_chain.paginate_found(params[:page], params[:query], params[:q])
        set_collection_ivar(result)
      end
      result
    end
  end
end
