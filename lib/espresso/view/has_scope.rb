require 'espresso/view'
require 'has_scope'

module Espresso::View
  mattr_accessor :scope_filter_wrapper_class, :scope_filter_ul_class
  self.scope_filter_wrapper_class = 'b-scope-filter'
  self.scope_filter_ul_class = 'b-hlist b-hlist_vline'

  module InstanceMethods
    def scope_filter(scopes)
      content_tag(:div, :class => Espresso::View.scope_filter_wrapper_class) do
        content_tag(:ul, :class => Espresso::View.scope_filter_ul_class) do
          scopes.inject([]) do |list, scope|
            list << content_tag(:li, link_to_unless_current(t(".#{scope}"),
                                           collection_path(scope => true)))
            list
          end.join
        end
      end
    end

  end
end
