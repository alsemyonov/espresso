require 'test_helper'
require 'example_model'

class ExampleModelTest < Test::Unit::TestCase
  should_have_class_methods :make_slug
  should_have_instance_methods :to_s

  {
    'Foo Bar' => 'foo-bar',
    'Baz Bar Foo' => 'baz-bar-foo'
  }.each do |name, slug|
    context "Example instance with name '#{name}'" do
      setup {
        @example = ExampleModel.new
        @example.name = name
      }

      should "represents to_s as '#{name}'" do
        assert_equal name, @example.to_s
      end
      should "make slug '#{slug}'" do
        assert_equal slug, ExampleModel.make_slug(@example)
      end
    end
  end
end
