# -----------------------------------------------------------------------------
# Normalizeable
# Force those user-inputs to behave!
# -----------------------------------------------------------------------------
# This concern add several self-modifiying bang methods to your model
# instances that allow them to sanitize and normalize user input.
#
#     before_validation do
#       normalize_email_attribute! :email
#       normalize_numeric_attribute! :phone
#       squish_attribute! :title
#       truncate_attribute! :body, max_length:1024
#     end
#
# These methods can gracefully save users from whitespace typos, but are
# also commonly required to protect against stifling attacks, especially
# when the content comes from anonymous users.

module Normalizeable

  # Forces a URI attribute to contain no spaces, trailing slashes and be
  # URL-safe encoded.
  # Modifies `self`. If the attribute is not `present?` it is set to `nil`.
  def normalize_uri_attribute!(attribute_name)
    new_value = self.send(attribute_name).try(:squish).try(:chomp, "/")
    if new_value.present?
      self.send("#{attribute_name}=", URI.encode(new_value))
    else
      self.send("#{attribute_name}=", nil)
    end
  end

  # Forces the given attribute to become a downcased, squished email address.
  # This prevents saving strangely formatted email addresses to the database.
  # Modifies `self`. If the attribute is not `present?` it is set to `nil`.
  def normalize_email_attribute!(attribute_name)
    new_value = self.send(attribute_name).downcase.to_s.squish
    if new_value.present?
      self.send("#{attribute_name}=", new_value)
    else
      self.send("#{attribute_name}=", nil)
    end
  end

  # Forces the given attribute to become a string that only contains numerals.
  # Useful for normalizing phone numbers or other ID numbers.
  # Modifies `self`. If the attribute is not `present?` it is set to `nil`.
  def normalize_numeric_attribute!(attribute_name)
    new_value = self.send(attribute_name).to_s.gsub(/\D/, "")
    if new_value.present?
      self.send("#{attribute_name}=", new_value)
    else
      self.send("#{attribute_name}=", nil)
    end
  end

  # Forces the given attribute to become a squished string.
  # Useful for normalizing input strings to strip trailing whitespace.
  # Modifies `self`. If the attribute is not `present?` it is set to `nil`.
  def squish_attribute!(attribute_name)
    new_value = self.send(attribute_name).to_s.squish
    if new_value.present?
      self.send("#{attribute_name}=", new_value)
    else
      self.send("#{attribute_name}=", nil)
    end
  end

  # Forces the given attribute to become a truncated string, cut off after `max_length`.
  # Useful for normalizing input strings and preventing stifling attacks.
  # Modifies `self`. If the attribute is not `present?` it is set to `nil`.
  def truncate_attribute!(attribute_name, max_length:)
    new_value = self.send(attribute_name).to_s.truncate(max_length, omission:"")
    if new_value.present?
      self.send("#{attribute_name}=", new_value)
    else
      self.send("#{attribute_name}=", nil)
    end
  end

end
