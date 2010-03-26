require 'action_controller'
require 'espresso/controller'

class ActionController::Base
  include Espresso::Controller
end
