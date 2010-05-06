require 'mongoid'
require 'espresso/model'

module Mongoid::Document
  include Espresso::Model
end
