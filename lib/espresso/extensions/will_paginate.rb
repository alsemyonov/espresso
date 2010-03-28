require 'espresso'

begin
  require 'will_paginate'
rescue LoadError
  raise <<-END
  Espresso require will_paginate gem to use WillPaginate extension.
  Please install it by:
  $ gem install will_paginate -v 2.3.12
  END
end

require 'espresso/collection/will_paginate'
require 'espresso/view/will_paginate'
