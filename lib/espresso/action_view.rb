module Espresso
  module ActionView
    autoload :Resources, 'espresso/action_view/resources'
    autoload :Scopes, 'espresso/action_view/scopes'
    autoload :Navigation, 'espresso/action_view/navigation'

    include Resources
    include Scopes
    include Navigation

    # Make body’s modifiers, based on controller_name and action_name
    def body_modifiers
      {:class => "m-#{controller_name} m-#{controller_name}_#{action_name}"}
    end
  end
end
