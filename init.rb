require 'activerecord'
require 'espresso/model'

ActiveRecord::Base.send(:include, Espresso::Model)
