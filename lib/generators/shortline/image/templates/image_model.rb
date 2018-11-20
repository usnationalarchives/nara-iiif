class Image < ApplicationRecord

  # -----------------------------------------------------------------------------
  # Associations
  # -----------------------------------------------------------------------------

  has_many :image_attachments, dependent: :destroy

  # -----------------------------------------------------------------------------
  # Validations
  # -----------------------------------------------------------------------------

  validates :title, {
    presence: true,
    uniqueness: true
  }

  validates :alt_text, {
    presence: true
  }

  # -----------------------------------------------------------------------------
  # Paperclip Attachments
  # -----------------------------------------------------------------------------

  has_attached_file :image_file, {
    path: "image/:id/:style.:extension",
    processors: [:thumbnail, :jpegtran],
    styles: {
      # Symbol definitions:
      # The “>” option will only shrink images larger than dimensions given
      # The “<” option will only enlarge images smaller than dimensions given
      # The “^” option will resize the image to fit maximally inside the dimensions (only used when cropping)
      # The “#” option is a shorthand to resize the image to fit maximally inside the dimensions and crop the rest, weighted at center (e.g. like “cover” in CSS) http://www.rubydoc.info/gems/paperclip/Paperclip/ClassMethods

      # References:
      # http://www.imagemagick.org/script/command-line-processing.php#geometry
      # http://www.imagemagick.org/Usage/resize/
      # https://www.smashingmagazine.com/2015/06/efficient-image-resizing-with-imagemagick/

      # Square
      square: { geometry: "600x600#", format: :jpg, processors: [:thumbnail, :jpegtran] },

      # Any aspect ratio
      small: { geometry: "300x300>", format: :jpg, processors: [:thumbnail, :jpegtran] },
      medium: { geometry: "600x600>", format: :jpg, processors: [:thumbnail, :jpegtran] },
      # large: { geometry: "1200x1200>", format: :jpg, processors: [:thumbnail, :jpegtran] },

      # 16:9 aspect ratio
      # sixteen_nine_medium: { geometry: "640x360#", format: :jpg, processors: [:thumbnail, :jpegtran] },
      # sixteen_nine_large: { geometry: "1280x720#", format: :jpg, processors: [:thumbnail, :jpegtran] },
    },
    # NOTE: In general, larger JPGs can be compressed more without a noticible difference in quality.
    convert_options: {
      original: %{-strip},
      square: %{-strip -interlace Line -quality 70 -define jpeg:fancy-upsampling=off},
      small: %{-strip -interlace Line -quality 80 -define jpeg:fancy-upsampling=off},
      medium: %{-strip -interlace Line -quality 70 -define jpeg:fancy-upsampling=off},

      # Example of how to crop an image from one side (leave the size in “styles” blank)
      # hero_large: %{-strip -interlace Line -quality 70 -thumbnail 1400x485^ -extent 1400x485 -gravity east},
    }
  }

  validates_attachment :image_file, {
    content_type: {
      content_type: [
        "image/jpg",
        "image/jpeg",
        "image/png",
        "image/gif"
      ]
    }
  }

  # -----------------------------------------------------------------------------
  # Tolaria
  # -----------------------------------------------------------------------------

  manage_with_tolaria using: {
    icon: "image",
    category: "Media",
    priority: 1,
    default_order: "created_at desc",
    paginated: true,
    permit_params: [
      :title,
      :alt_text,
      :keywords,
      :caption,
      :attribution,
      :image_file
    ]
  }

  # -----------------------------------------------------------------------------
  # Instance Methods
  # -----------------------------------------------------------------------------

  def cms_preview
    self.image_file.url(:medium)
  end

end
