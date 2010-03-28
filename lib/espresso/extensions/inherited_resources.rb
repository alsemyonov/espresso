require 'espresso'

begin
  require 'inherited_resources'
rescue LoadError
  raise <<-END
  Espresso require inherited_resources gem to use InheritedResources extension.
  Please install it by:
  $ gem install inherited_resources -v 1.0.5
  END
end

require 'espresso/model/inherited_resources'
require 'espresso/view/inherited_resources'
require 'espresso/controller/inherited_resources'
