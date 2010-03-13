module Espresso
  module ActionView
    autoload :Resources, 'espresso/action_view/resources'
    autoload :Scopes, 'espresso/action_view/scopes'
    autoload :Navigation, 'espresso/action_view/navigation'
    autoload :FormBuilder, 'espresso/action_view/form_builder'
    autoload :Stats, 'espresso/action_view/stats'

    include Resources
    include Scopes
    include Navigation
    include Stats

    # Make body’s modifiers, based on controller_name and action_name
    def body_modifiers
      {:class => "m-#{controller_name} m-#{controller_name}_#{action_name}"}
    end
  end
end

Formtastic::SemanticFormHelper.builder = Espresso::ActionView::FormBuilder
