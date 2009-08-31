module Espresso
  module Helpers
    inlude WillPaginate::ViewHelpers

    def simple_search
      form_tag(url_for(:action => :index), :method => :get, :class => 'b_search b_search-simple') do
        inform = returning '' do |result|
          result << text_field_tag(:q, params[:q])
          result << submit_tag(t('krasivotokak.espresso.find', :default => 'Find!'), :class => 'submit')
        end
        concat inform
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
