require 'action_view'
require 'espresso/view'

class ActionView::Base
  include Espresso::View
end
