require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'redgreen'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'espresso'

require 'active_support/core_ext/string'
module Test
  module Unit
    class TestCase
      def self.should_have_class_methods(*methods)
        get_options!(methods)
        klass = described_type
        methods.each do |method|
          should "respond to class method ##{method}" do
            assert_respond_to(klass, method, "#{klass.name} does not have class method #{method}")
          end
        end
      end

      def self.should_have_instance_methods(*methods)
        get_options!(methods)
        klass = described_type
        methods.each do |method|
          should "respond to instance method ##{method}" do
            assert_respond_to(klass.new, method, "#{klass.name} does not have instance method #{method}")
          end
        end
      end
    end

    class TestCaseTest < TestCase
      should_have_class_methods :should_have_class_methods, :should_have_instance_methods
    end
  end
end
