require 'espresso'

module Espresso
  module Controller
    extend Espresso::Concern

    module ClassMethods
    end

    module InstanceMethods
    protected
      # Render view if present, otherwise fallback to standard view in Espresso
      # @param [String, Symbol] view_name name of a view template
      # @param [Hash, String] options options to render method
      # @option options [String, Symbol] :fallback (:espresso) fallback prefix or full path to fallback template
      def render_with_fallback(view_name, options = {})
        if options === String
          prefix, options = options, {}
        else
          options ||= {}
          prefix = options.delete(:fallback) { :espresso }
        end
        render view_name, options
      rescue ::ActionView::MissingTemplate
        render (prefix.is_a?(Symbol) ? "#{prefix}/#{view_name}" : prefix), options
      end
    end
  end
end

if defined?(InheritedResources)
  require 'espresso/controller/inherited_resources'
end
