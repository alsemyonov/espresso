require 'espresso/view'
require 'action_view'
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
          send(:"error_#{self.class.inline_errors}", [*errors]) if errors.present?
        else
          nil
        end
      end

      def submit_default_value
        model = if object.class.respond_to?(:model_name)
                  object.class.model_name.human
                else
                  @object_name.to_s.humanize
                end

        defaults = []
        defaults << :"helpers.submit.#{object_name}.#{form_action}"
        defaults << :"helpers.submit.#{form_action}"
        defaults << "#{form_action.to_s.humanize} #{model}"

        I18n.t(defaults.shift, :model => model, :default => defaults)
      end

      def simple_date_input(method, options)
        html_options = options.delete(:input_html) { {} }
        self.label(method, options_for_label(options)) <<
        self.date_select(method, html_options)
      end

      def simple_datetime_input(method, options)
        html_options = options.delete(:input_html) { {} }
        self.label(method, options_for_label(options)) <<
        self.datetime_select(method, html_options)
      end

      def phone_input(method, options)
        basic_input_helper(:phone_field, :string, method, options)
      end
      alias_method :telephone_input, :phone_input

      def numeric_input(method, options)
        basic_input_helper(:number_field, :numeric, method, options)
      end

      def email_input(method, options)
        options[:input_html] ||= {}
        options[:input_html][:autocapitalize] ||= 'off'
        basic_input_helper(:email_field, :string, method, options)
      end

      def url_input(method, options)
        basic_input_helper(:url_field, :string, method, options)
      end

      def range_input(method, options)
        html_options = options.delete(:input_html)    { {} }
        html_options[:step] ||= options.delete(:step) { 1  }
        data_options = options.keys.find_all {|a| a.to_s =~ /^data-/ }
        (data_options + [:min, :max, :in]).each do |option|
          if options.key?(option)
            html_options[option] = options.delete(option)
          end
        end
        html_options = default_string_options(method, :numeric).merge(html_options)

        self.label(method, options_for_label(options)) <<
          template.content_tag(:div, range_field(method, html_options), :class => 'b-range')
      end

      def dual_range_input(method, options)
        html_options = options.delete(:input_html)    { {} }
        html_options[:step] ||= options.delete(:step) { 1  }
        data_options = options.keys.find_all {|a| a.to_s =~ /^data-/ }
        (data_options + [:min, :max, :in]).each do |option|
          if options.key?(option)
            html_options[option] = options.delete(option)
          end
        end
        html_options = default_string_options(method, :numeric).merge(html_options)

        self.label(method, options_for_label(options)) <<
          template.content_tag(:span,
                               range_field("#{method}_begin", html_options) +
                                 range_field("#{method}_end", html_options),
                               :class => 'b-range b-range_dual')
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
