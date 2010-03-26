require 'espresso/model'

class ExampleModel
  include Espresso::Model
  self.model_modifiers << :safe

  attr_accessor :id, :name, :safe

  def initialize(id = nil, safe = false)
    self.id = id
    self.safe = safe
  end

  def safe?
    safe == true
  end
end

class NonModel
  def id
    6
  end
end
