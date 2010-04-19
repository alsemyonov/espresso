require 'espresso'
require 'active_support/ordered_hash'

module Espresso
  module Manage
    autoload :Field,        'espresso/manage/field'
    autoload :FieldSet,     'espresso/manage/field_set'
    autoload :BaseOptions,  'espresso/manage/base_options'
    autoload :Options,      'espresso/manage/options'
  end
end
