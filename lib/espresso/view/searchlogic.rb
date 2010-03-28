require 'espresso/view'
require 'searchlogic'

module Espresso::View
  module InstanceMethods
    def simple_search
      ''.tap do |form|
        form << form_tag(url_for(:action => :index), :method => :get)
        form << content_tag(:table, :class => 'b-search') do
          content_tag(:tr) do
            ''.tap do |result|
              result << content_tag(:td,
                                    content_tag(:div,
                                                text_field_tag(:q,
                                                               params[:q],
                                                               :type => 'search'),
                                                :class => 'b-input'),
                                    :class => 'input')
              result << content_tag(:td,
                                    submit_tag(t('espresso.view.find',
                                                 :default => 'Find!'),
                                               :class => 'submit'),
                                    :class => 'button')
            end
          end
        end
        form << yield if block_given?
        form << '</form>'
      end
    end

  end
end
