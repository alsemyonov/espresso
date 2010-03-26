require 'haml'
require 'haml/buffer'
require 'espresso/view'

class Haml::Buffer
  include Espresso::View
  # Takes an array of objects and uses the class and id of the first
  # one to create an attributes hash.
  # The second object, if present, is used as a prefix,
  # just like you can do with `dom_id()` and `dom_class()` in Rails
  def parse_object_ref(ref)
    prefix = ref[1]
    ref = ref[0]
    # Let's make sure the value isn't nil. If it is, return the default Hash.
    return {} if ref.nil?
    class_name = underscore(ref.class)
    id = "#{class_name}_#{ref.id || 'new'}"

    if ref.respond_to?(:model_modifiers)
      class_name = model_classes(ref)
    elsif prefix
      class_name = "#{prefix}_#{class_name}"
      id = "#{prefix}_#{id}"
    end

    {'id' => id, 'class' => class_name}
  end
end
