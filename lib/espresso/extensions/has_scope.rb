require 'espresso'

begin
  require 'has_scope'
rescue LoadError
  raise <<-END
  Espresso require has_scope gem to use HasScope extension.
  Please install it by:
  $ gem install has_scope -v 0.4.2
  END
end

require 'espresso/view/has_scope'
