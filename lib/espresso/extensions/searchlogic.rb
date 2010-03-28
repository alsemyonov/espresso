require 'espresso'

begin
  require 'searchlogic'
rescue LoadError
  raise <<-END
  Espresso require searchlogic gem to use Searchlogic extension.
  Please install it by:
  $ gem install searchlogic -v 2.4.12
  END
end

require 'espresso/collection/searchlogic'
require 'espresso/view/searchlogic'
