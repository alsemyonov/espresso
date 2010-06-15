require 'espresso/view'
require 'searchlogic'
require 'searchlogic/rails_helpers'

module Espresso::View
  module InstanceMethods
    include Searchlogic::RailsHelpers

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

    # Creates a link that alternates between acending and descending. It basically
    # alternates between calling 2 named scopes: "ascend_by_*" and "descend_by_*"
    #
    # By default Searchlogic gives you these named scopes for all of your columns, but
    # if you wanted to create your own, it will work with those too.
    #
    # Examples:
    #
    #   order @search, :by => :username
    #   order @search, :by => :created_at, :as => "Created"
    #
    # This helper accepts the following options:
    #
    # * <tt>:by</tt> - the name of the named scope. This helper will prepend this value with "ascend_by_" and "descend_by_"
    # * <tt>:as</tt> - the text used in the link, defaults to whatever is passed to :by
    # * <tt>:ascend_scope</tt> - what scope to call for ascending the data, defaults to "ascend_by_:by"
    # * <tt>:descend_scope</tt> - what scope to call for descending the data, defaults to "descend_by_:by"
    # * <tt>:params</tt> - hash with additional params which will be added to generated url
    # * <tt>:params_scope</tt> - the name of the params key to scope the order condition by, defaults to :search
    def order(search, options = {}, html_options = {})
      options[:params_scope] ||= :search
      if !options[:as]
        id = options[:by].to_s.downcase == "id"
        options[:as] = id ? options[:by].to_s.upcase : options[:by].to_s.humanize
      end
      options[:ascend_scope] ||= "ascend_by_#{options[:by]}"
      options[:descend_scope] ||= "descend_by_#{options[:by]}"
      ascending = search.order.to_s == options[:ascend_scope]
      new_scope = ascending ? options[:descend_scope] : options[:ascend_scope]
      selected = [options[:ascend_scope], options[:descend_scope]].include?(search.order.to_s)
      if selected
        css_classes = html_options[:class] ? html_options[:class].split(" ") : []
        if ascending
          options[:as] = "↑&nbsp;#{options[:as]}"
          css_classes << "ascending"
        else
          options[:as] = "↓&nbsp;#{options[:as]}"
          css_classes << "descending"
        end
        html_options[:class] = css_classes.join(" ")
      end
      url_options = {
        options[:params_scope] => search.conditions.merge( { :order => new_scope } )
      }.deep_merge(options[:params] || {})
      link_to options[:as].html_safe, url_for(url_options), html_options
    end
  end
end
