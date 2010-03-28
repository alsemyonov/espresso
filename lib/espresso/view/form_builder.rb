require 'espresso/view'
require 'formtastic'

module Espresso
  module View
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
        model = if object.class.respond_to?(:model_name)
                  object.class.human_name
                else
                  @object_name.to_s.humanize
                end

        defaults = []
        defaults << :"helpers.submit.#{object_name}.#{form_action}"
        defaults << :"helpers.submit.#{form_action}"
        defaults << "#{form_action.to_s.humanize} #{model}"

        I18n.t(defaults.shift, :model => model, :default => defaults)
      end

      def commit_button(*args)
        options = args.extract_options!

        button_html = options.delete(:button_html) || {}
        button_html.merge!(:class => [button_html[:class], form_action].compact.join(' '))
        element_class = ['commit', options.delete(:class)].compact.join(' ')
        accesskey = (options.delete(:accesskey) || @@default_commit_button_accesskey) unless button_html.has_key?(:accesskey)
        button_html = button_html.merge(:accesskey => accesskey) if accesskey  
        template.content_tag(:li, self.submit(options.delete(:label), button_html), :class => element_class)
      end

    protected
      def model_object
        @object.respond_to?(:to_model) ? @object.to_model : @object
      end

      def form_action
        model_object ? (model_object.new_record? ? :create : :update) : :submit
      end
    end
  end
end
