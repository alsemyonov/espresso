require 'espresso/manage'

module Espresso::Manage
  class Field
    attr_accessor :name, :options, :link, :manage_options

    def self.to_field(field, manage)
      if field.is_a?(Field)
        field
      else
        name, options = field
        manage.fields[name.to_sym] || Field.new(manage, name, options)
      end
    end

    def initialize(manage_options, name, options = {})
      self.manage_options = manage_options
      self.name = name.to_sym
      self.options = options
      @link = false
    end

    def real_options(view = nil)
      options.inject({}) do |result, (name, value)|
        result[name] = case value
                       when Proc
                         if value.arity == 1
                           value.call(view)
                         else
                           value.call
                         end
                       else
                         value
                       end
        result
      end
    end

    def to_input(view = nil)
      [name, real_options(view)]
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

    def value_method
      unless @value_method
        association_name = name.to_s.gsub(/_id$/, '')
        humanized_name = "human_#{association_name}"
        model_class = self.manage_options.model_class

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
      object.send(value_method)
    end
  end
end
