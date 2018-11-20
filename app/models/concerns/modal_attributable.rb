# -----------------------------------------------------------------------------
# ModalAttributable
# Add fancy enumerated columns to your model
# -----------------------------------------------------------------------------
# This concern requires that you create a text field on your model
# (the rest of these examples use `status` as the example field)
#
#   add_column :blog_posts, :status, :text, null:false, default:"draft"
#
# After including ModalAttributable, you can then call
# modal_attribute in the class definition like so:
#
#   modal_attribute :status, {
#     published: "Published",
#     draft: "Draft",
#     retired: "Retried",
#   }
#
# Then the following methods become available on your class:
#
# Get back your original hash (either method works):
#
#   Klass.status_values
#   Klass::STATUS_VALUES
#
# Get the human-friendly string for your model’s status:
#
#   @klass.status_string
#
# Check programmatically on the status:
#
#   @klass.status.published?
#   @klass.status.draft?
#   @klass.status.retired?
#
# Assign a new status:
#
#   @klass.status = :draft
#
# In addition, your model will now validate inclusion of
# status in Klass.status_values

module ModalAttributable

  extend ActiveSupport::Concern

  class_methods do

    def modal_attribute(attribute_name, values = {})

      # Force the incoming hash to be keyed with strings
      values = HashWithIndifferentAccess.new(values).to_hash

      # Raise an error if the hash keys can't be valid function names
      values.each_key do |key|
        unless /[@$"]/ !~ key.to_s.to_sym.inspect
          raise ArgumentError, "modal_attribute key '#{key}' must be a valid method name, can't start with numbers or symbol"
        end
      end

      attribute_name = attribute_name.downcase.to_sym
      attribute_const = "#{attribute_name.upcase}_VALUES".to_sym

      # Klass::STATUS_VALUES
      self.const_set(attribute_const, values)

      # Klass.status_values
      self.define_singleton_method("#{attribute_name}_values") do
        self.const_get(attribute_const)
      end

      # @klass.status
      define_method(attribute_name) do
        self[attribute_name].to_s.inquiry
      end

      # @klass.status_string
      define_method("#{attribute_name}_string") do
        self.class.const_get(attribute_const, true).fetch(self.send(attribute_name))
      end

      # @klass.status = "new_status"
      define_method("#{attribute_name}=") do |new_value|
        self[attribute_name] = new_value.to_s
      end

      # The enum column must be one of the keys in the hash
      self.validates attribute_name, {
        inclusion: {
          in: values.keys,
        }
      }

    end

  end

end
