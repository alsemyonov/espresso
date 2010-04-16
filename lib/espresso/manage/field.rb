require 'espresso/manage'

module Espresso::Manage
  class Field
    attr_accessor :name, :options, :link

    def self.to_field(field)
      if field.is_a?(Field)
        field
      else
        Field.new(*Array(field))
      end
    end

    def initialize(name, options = {})
      self.name, self.options = name.to_sym, options
      @link = false
    end

    def real_options
      options.inject({}) do |result, (name, value)|
        result[name] = case value
                       when Proc
                         value.call
                       else
                         value
                       end
        result
      end
    end

    def to_input
      [name, real_options]
    end

    def to_sym
      name
    end

    def to_s
      name.to_s
    end

    def [](name)
      options[name]
    end

    def []=(name, value)
      options[name] = value
    end

    def link!
      self.link = true
    end

    alias_method :link?, :link

    def value_method(model_class = nil)
      unless @value_method
        association_name = name.to_s.gsub(/_id$/, '')
        humanized_name = "human_#{association_name}"

        @value_method = if model_class.instance_methods.include?(humanized_name)
                          humanized_name
                        elsif model_class.instance_methods.include?(association_name)
                          association_name
                        else
                          name
                        end
      end
      @value_method
    end

    def value_for(object)
      object.send(value_method(object.class))
    end
  end
end
