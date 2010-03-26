require 'active_record'
require 'espresso/model'

class ActiveRecord::Base
  include Espresso::Model
end
