# -----------------------------------------------------------------------------
# HasImages allows you to associate images to another model
# -----------------------------------------------------------------------------
#
# Associated Model Usage:
#
# images :feature_image
# ...
# manage_with_tolaria using: {
#   permit_params: [
#     feature_image_image_attachment_attributes: self.image_attachment_attributes
#   ]
# }
#
# Admin Form Usage:
#
# <%= f.image :feature_image, hint: "This image will be used in promos/teasers linking to this article throughout the site. (doesn't appear on page)" %>

module HasImages
  extend ActiveSupport::Concern

  module ClassMethods

    def images(*image_names)
      image_names.each do |image_name|

        has_one "#{image_name}_image_attachment".to_sym,
          lambda { where(collection: image_name.to_s) }, {
            class_name: "ImageAttachment",
            as: :imageable,
            dependent: :destroy
          }

        has_one image_name,
          through: "#{image_name}_image_attachment".to_sym,
          source: :image

        accepts_nested_attributes_for "#{image_name}_image_attachment"

      end

      define_singleton_method("image_attachment_attributes") do
        [ :image_id ]
      end

    end

  end

end
