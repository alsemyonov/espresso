require 'test_helper'
require 'espresso/collection'

class Espresso::CollectionTest < Test::Unit::TestCase
  should_have_instance_methods(:search, :to_a) { Espresso::Collection.new(nil) }
end
