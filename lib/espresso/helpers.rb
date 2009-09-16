module Espresso
  module Helpers
    include WillPaginate::ViewHelpers

    def simple_search
      returning '' do |form|
        form << form_tag(url_for(:action => :index), :method => :get)
        form << content_tag(:table, :class => 'b_search') do
                  content_tag(:tr) do
                    returning '' do |result|
                      result << content_tag(:td,
                                            content_tag(:div, text_field_tag(:q, params[:q], :type => 'search'), :class => 'b_input'),
                                            :class => 'input')
                      result << content_tag(:td,
                                            submit_tag(t('krasivotokak.espresso.find', :default => 'Find!'), :class => 'submit'),
                                            :class => 'button')
                    end
                  end
                end
        form << yield if block_given?
        form << '</form>'
      end
    end

    def will_paginate_with_i18n(collection, options = {})
      will_paginate_without_i18n(collection,
                                 options.merge({
        :class => 'b_pagination',
        :previous_label => t('krasivotokak.espresso.previous', :default => '← Previous'),
        :next_label =>     t('krasivotokak.espresso.next', :default => 'Next →')}))
    end
    alias_method_chain :will_paginate, :i18n
  end
end
