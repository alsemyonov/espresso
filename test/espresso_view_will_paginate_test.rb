require 'test_helper'
require 'espresso/view/will_paginate'


class Espresso::ViewTest < Test::Unit::TestCase
  include Espresso::View

  should_have_instance_methods :will_paginate, :paginated_list
end
