require 'espresso'
require 'espresso/model'

module Espresso
  ActionView = View
  autoload :Resources, 'espresso/deprecated/resources'
  module Model
    module ClassMethods
      # @deprecated Use model_modifiers instead
      def model_attrs=(attrs)
        model_modifiers=attrs
      end

      def search_results(page = nil, query = {}, simple_query = nil)
        collection(:page => page, :search => query)
      end
    end
  end
end
