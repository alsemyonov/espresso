module Espresso
  module ActionView
    module Scopes
      def simple_search
        returning '' do |form|
          form << form_tag(url_for(:action => :index), :method => :get)
          form << content_tag(:table, :class => 'b-search') do
                    content_tag(:tr) do
                      returning '' do |result|
                        result << content_tag(:td,
                                              content_tag(:div, text_field_tag(:q, params[:q], :type => 'search'), :class => 'b-input'),
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

      def scope_filter(scopes)
        items = scopes.inject([]) do |list, scope|
          list << link_to_unless_current(t(".#{scope}"), collection_path(scope => true))
          list
        end

        content_tag(:div, :class => 'b-scope-filter') do
          content_tag(:ul, :class => 'b-hlist b-hlist_vline') do
                                  "<li>#{items.join('<li></li>')}</li>"
          end
        end
      end
    end
  end
end
