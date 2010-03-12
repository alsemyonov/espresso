require 'formtastic'

module Espresso
  module ActionView
    class FormBuilder < Formtastic::SemanticFormBuilder
      def submit(value=nil, options={})
        value, options = nil, value if value.is_a?(Hash)
        value ||= submit_default_value
        @template.submit_tag(value, options.reverse_merge(:id => "#{object_name}_submit"))
      end

      def inline_errors_for(method, options = nil) #:nodoc:
        if render_inline_errors?
          errors = Array(@object.errors[method.to_sym]) +
            Array(@object.errors[:"#{method}_id"])
          send(:"error_#{@@inline_errors}", [*errors]) if errors.present?
        else
          nil
        end
      end

      def submit_default_value
        object = @object.respond_to?(:to_model) ? @object.to_model : @object
        key    = object ? (object.new_record? ? :create : :update) : :submit

        model = if object.class.respond_to?(:model_name)
                  object.class.human_name
                else
                  @object_name.to_s.humanize
                end

        defaults = []
        defaults << :"helpers.submit.#{object_name}.#{key}"
          defaults << :"helpers.submit.#{key}"
          defaults << "#{key.to_s.humanize} #{model}"

          I18n.t(defaults.shift, :model => model, :default => defaults)
      end
    end
  end
end
