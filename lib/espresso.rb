$KCODE = 'u'
require 'active_support/core_ext/module'

module Espresso
  autoload :Model, 'espresso/model'
  autoload :View, 'espresso/view'
  autoload :Controller, 'espresso/controller'
  autoload :Collection, 'espresso/collection'
  autoload :Concern, 'espresso/concern'
  autoload :Manage, 'espresso/manage'

  BASE_MODULES = %w(model view controller)

  mattr_accessor :extensions
  self.extensions = []

  # Configures Espresso.
  # By default, loads all extensions
  def self.configure
    if block_given?
      yield
    else
      uses :all
    end
  end

  # Loads Espresso extensions
  # @param [String, Symbol] extension name of the Espresso extension
  def self.uses(extension)
    require("espresso/extensions/#{extension}")
  end
end

if defined?(ActiveRecord)
  Espresso.uses :active_record
end

if defined?(Mongoid)
  Espresso.uses :mongoid
end

if defined?(ActionView)
  Espresso.uses :action_view
end

if defined?(ActionController)
  Espresso.uses :action_controller
end

if defined?(Haml)
  Espresso.uses :haml
end

require 'espresso/deprecated'
