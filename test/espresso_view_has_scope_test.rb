require 'test_helper'
require 'action_controller'
require 'espresso/view/has_scope'


class Espresso::ViewTest < Test::Unit::TestCase
  include Espresso::View

  should_have_class_methods :scope_filter_wrapper_class, :scope_filter_ul_class
  should_have_instance_methods :scope_filter
end
