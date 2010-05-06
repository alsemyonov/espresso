require 'espresso/view'
require 'will_paginate/view_helpers'

module Espresso::View
  module InstanceMethods
    include WillPaginate::ViewHelpers::ActionView

    def will_paginate_with_i18n(collection, options = {})
      will_paginate_without_i18n(collection,
                                 options.merge({
        :class => 'b-pagination',
        :previous_label => t('espresso.navigation.previous', :default => '← Previous'),
        :next_label =>     t('espresso.navigation.next', :default => 'Next →')}))
    end
    alias_method_chain :will_paginate, :i18n

    def paginated_list(collection_name, options = {})
      collection = options.delete(:collection) do
        instance_variable_get("@#{collection_name}")
      end
      prefix = options.delete(:prefix)
      prefix = prefix ? " b-list_#{prefix}_#{collection_name}" : nil
      start = (collection.respond_to?(:offset) ? collection.offset : 0) + 1
      ''.tap do |result|
        result << content_tag(:ol,
                              render(collection),
                              :class => "b-list b-list_#{collection_name}#{prefix}",
                              :start => start)
        if collection.respond_to?(:total_pages)
          result << (will_paginate(collection, options) || '')
        end
      end
    end
  end
end
