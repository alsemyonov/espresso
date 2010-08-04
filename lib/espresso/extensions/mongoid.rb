require 'mongoid'
require 'espresso/model'

module Mongoid::Document
  include Espresso::Model

  module ClassMethods
    def field_names
      fields.keys.map do |field_name|
        field_name.gsub(/_id$/, '').to_sym
      end
    end
  end
end
