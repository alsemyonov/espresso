module Espresso
  module ActionController
    def resources
      Espresso::Resources.resources(self)
    end
  end
end
