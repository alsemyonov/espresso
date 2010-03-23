module Espresso
  MODEL_PREFIX = 'b'

  autoload :Model, 'espresso/model'
  autoload :Resources, 'espresso/resources'
  autoload :ActionView, 'espresso/action_view'
  autoload :ResourcesHelpers, 'espresso/resources_helpers'

  # Make a list of locale files, provided by gem
  def self.locale_files
    Dir[File.join(File.dirname(__FILE__), 'espresso', 'locales', '*')]
  end
end

if defined?(ActiveRecord)
  ActiveRecord::Base.send(:include, Espresso::Model)
end

if defined?(ActionController)
  ActionController::Base.send(:include, Espresso::ResourcesHelpers)
end

if defined?(ActionView)
  ActionView::Base.send(:include, Espresso::ActionView)
end

require 'i18n'
I18n.load_path.unshift(*Espresso.locale_files)

require 'espresso/haml'
