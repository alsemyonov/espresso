module Espresso
  def self.locale_files
    Dir[File.join(File.dirname(__FILE__), 'sugar', 'locales', '*')]
  end
end

require 'espresso/objects_controller'
require 'espresso/model'

if defined? Rails
  ActiveRecord::Base.send :include, Espresso::Model if defined? ActiveRecord
  ActionView::Base.send :include, Espresso::Helpers if defined? ActionView
  I18n.load_path.unshift(*Espresso.locale_files)
end
