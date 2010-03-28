require 'espresso/view'
require 'will_paginate/view_helpers'

module Espresso::View
  module InstanceMethods
    include WillPaginate::ViewHelpers

    def will_paginate_with_i18n(collection, options = {})
      will_paginate_without_i18n(collection,
                                 options.merge({
        :class => 'b-pagination',
        :previous_label => t('espresso.navigation.previous', :default => '← Previous'),
        :next_label =>     t('espresso.navigation.next', :default => 'Next →')}))
    end
    alias_method_chain :will_paginate, :i18n
  end
end
