require 'test_helper'
require 'espresso/view'

class Espresso::ViewTest < Test::Unit::TestCase
  should_have_class_methods :block_prefix

  include Espresso::View

  {
    'b-example' => ['example'],
    'b-example b-example_foo' => ['example', %w(foo)],
    'b-example b-example_foo b-example_bar' => ['example', %w(foo bar)],
    'o-example' => ['example', [], {:type => 'o'}],
    'y-example y-example_foo y-example_bar y-example_baz' => ['example', %w(foo bar baz), {:type => 'y'}],
  }.each do |result, params|
    should "build “#{result}” from #{params.inspect}" do
      assert_equal result, self.class.espresso_block_classes(*params)
    end
  end

  class Example
    def self.model_modifiers
      [:foo]
    end
  end

  class ::FooExample < Example
    def foo?
      true
    end
  end

  should 'build “b-espresso-view-test-example” from Example instance' do
    @example = Example.new
    assert_equal 'b-espresso-view-test-example', model_classes(@example)
  end

  should 'build “b-foo-example b-foo-example_foo” from FooExample instance' do
    @example = FooExample.new
    assert_equal 'b-foo-example b-foo-example_foo', model_classes(@example)
  end
end
