require 'espresso/extensions/inherited_resources'

module Espresso
  module Resources
    extend Espresso::Concern

    included do
      resources
    end
  end
end
