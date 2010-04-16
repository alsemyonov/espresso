require 'espresso/controller/inherited_resources'
require 'espresso/view/inherited_resources/manage'

module Espresso
  module Controller
    module InheritedResourcesManage
      extend Espresso::Concern

      module InstanceMethods
        def index
          super do |format|
            format.html do
              render_with_fallback('index')
            end
          end
        end

        def edit
          super do |format|
            format.html do
              render_with_fallback('edit')
            end
          end
        end

        def new
          super do |format|
            format.html do
              render_with_fallback('new')
            end
          end
        end

        def show
          super do |format|
            format.html do
              render_with_fallback('show', 'espresso/edit')
            end
          end
        end

        def create
          super do |success, failure|
            success.html do
              redirect_to collection_path
            end
            failure.html do
              render_with_fallback('new')
            end
          end
        end

        def update
          super do |success, failure|
            success.html do
              redirect_to collection_path
            end
            failure.html do
              render_with_fallback('edit')
            end
          end
        end

      protected
        def manage_options
          self.class.manage_options
        end
      end

      module ClassMethods
      end
    end
  end
end
