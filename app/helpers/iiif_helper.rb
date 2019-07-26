##
# This module contains methods for forming IIIF Image server URLs

module IIIFHelper

  ##
  # Returns a IIIF info URL for the attachment on an Image record
  #
  # example:
  #
  # <%= iiif_info_url(@post.image) %>

  def iiif_id_url(image)
    "#{base_path}/#{attachment_key(image)}"
  end

  def iiif_info_url(image)
    "#{base_path}/#{attachment_key(image)}/info.json"
  end

  ##
  # Returns URLs to predefined scaled images from the IIIF image server
  #
  # example:
  #
  # <%= iiif_variant_url(@post.image, :small) %>

  def iiif_variant_url(image, style)
    style = style.to_sym

    width = style == :small ? 300 :       # :small = 300 pixels
            style == :medium ? 600 :      # :medium = 600 pixels
            style == :large ? 1000 : 100  # :large = 1000 pixels, the default is 100 pixels

    "#{base_path}/#{attachment_key(image)}/full/#{width},/0/default.jpg"
  end

  def iiif_url_from_params(image, params={})
    ## Param Defaults 
    # identifier	null
    # region	"full"
    # size	"full"
    # rotation	"0"
    # quality	"default"
    # format	"jpg"
    config = {
      identifier: attachment_key(image)
    }

    IiifUrl.from_params(
      config.merge(params)
    )
  end

  ##
  # Returns the base IIIF API path
  def base_path
    "#{ENV.fetch("IMAGE_API_URL")}/iiif/2"
  end

  private

  ##
  # Returns an image attachment key. The key is the filename on S3
  def attachment_key(image)
    image.image.attachment.blob.key
  end

end