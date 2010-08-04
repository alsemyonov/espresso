require 'active_record'
require 'espresso/model'

class ActiveRecord::Base
  include Espresso::Model

  def self.field_names
    columns.collect do |column|
      column_name = column.name
      column_name.gsub(/_id$/, '').to_sym
    end
  end
end
