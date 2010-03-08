module Espresso
  MODEL_PREFIX = 'b'

  autoload :Model, 'espresso/model'
  autoload :ObjectsController, 'espresso/objects_controller'
  autoload :Resource, 'espresso/resource'
  autoload :Helpers, 'espresso/helpers'

  def self.locale_files
    Dir[File.join(File.dirname(__FILE__), 'espresso', 'locales', '*')]
  end
end

require 'active_record'
ActiveRecord::Base.send(:include, Espresso::Model)

require 'action_view'
ActionView::Base.send(:include, Espresso::Helpers)

require 'i18n'
I18n.load_path.unshift(*Espresso.locale_files)

require 'espresso/haml'
