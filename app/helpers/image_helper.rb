##
# This module contains helper methods for working with ActiveStorage
# managed images

module ImageHelper

  ##
  # Returns a service url to an image asset
  #
  # example:
  #
  # <%= image_variant_url(@post.image, :small) %>
  def image_variant_url(image, style)
    style = style.try(:to_sym)

    operations = style == :small ? {resize: "300x300"} :
                 style == :medium ? {resize: "600x600"} :
                 {resize: "100x100"}

    image.image.variant(operations).processed.service_url
  end
end