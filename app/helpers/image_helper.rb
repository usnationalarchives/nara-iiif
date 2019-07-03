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
    case style.to_sym
    when :small
      image.image.variant(resize: "300x300").processed.service_url
    else
      nil
    end
  end
end