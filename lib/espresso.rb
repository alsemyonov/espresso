$KCODE = 'u'

module Espresso
  autoload :Model, 'espresso/model'
  autoload :View, 'espresso/view'
  autoload :Controller, 'espresso/controller'

  BASE_MODULES = %w(model view controller)

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
  # @param [true, false] extend_modules whether to extend modules Model, View, Controller or not
  def self.uses(extension, extend_modules = true)
    Kernel.require "espresso/extensions/#{extension}"
    if extend_modules && extension != :all
      extension = extension.to_s.classify
      BASE_MODULES.each do |module_name|
        mod = const_get(module_name.classify)
        extend_module(mod, mod.const_get(extension))
      end
    end
  end

  # Extend module InstanceMethods and ClassMethods with extension‘s one
  # @param [Module] mod module to extend
  # @param [Module] extension module, containing extensions
  def self.extend_module(mod, extension)
    mod.const_get(:ClassMethods).send(:include,
                                      extension.const_get(:ClassMethods))
    mod.const_get(:InstanceMethods).send(:include,
                                         extension.const_get(:InstanceMethods))
  end

  # Requires Espressso extension and submodules
  # @param [String, Symbol] library extension name to require
  # @param [Array, nil] submodules list of submodules to include
  def self.require(library, submodules = BASE_MODULES)
    Kernel.require(library)
    submodules.each do |module_name|
      Kernel.require("espresso/#{module_name}/#{library}")
    end
    Kernel.require("espresso/")
  rescue LoadError
    raise "Espresso require #{library} to use Espresso::#{library.classify} extension"
  end
end

if defined?(ActiveRecord)
  Espresso.uses :active_record, false
end

if defined?(ActionView)
  Espresso.uses :action_view, false
end

if defined?(ActionController)
  Espresso.uses :action_controller, false
end

if defined?(Haml)
  Espresso.uses :haml, false
end
