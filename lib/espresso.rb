module Espresso
end

require 'espresso/objects_controller'
require 'espresso/model'

if defined? Rails
  ActiveRecord::Base.send :include, Espresso::Model if defined? ActiveRecord
  ActionView::Base.send :include, Espresso::Helpers if defined? ActionView
end
