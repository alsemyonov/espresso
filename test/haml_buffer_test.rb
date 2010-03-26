require 'test_helper'
require 'espresso/extensions/haml'
require 'example_model'

class Haml::BufferTest < Test::Unit::TestCase
  context 'Haml::Buffer instance' do
    setup { @buffer = Haml::Buffer.new }

    {
      [ExampleModel.new(1)] => {'id' => 'example_model_1', 'class' => 'b-example-model'},
      [NonModel.new, :prefix] => {'id' => 'prefix_non_model_6', 'class' => 'prefix_non_model'},
      [ExampleModel.new(5, true)] => {'id' => 'example_model_5', 'class' => 'b-example-model b-example-model_safe'}
    }.each do |ref, result|
      should "parse #{ref.inspect} ref to #{result.inspect} " do
        assert_equal(result, @buffer.parse_object_ref(ref))
      end
    end
  end
end
