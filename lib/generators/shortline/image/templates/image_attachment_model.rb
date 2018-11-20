class ImageAttachment < ActiveRecord::Base

  include CollectionPrioritizable

  before_validation do
    self.destroy unless self.image.present?
  end

  # -----------------------------------------------------------------------------
  # Associations
  # -----------------------------------------------------------------------------

  belongs_to :imageable, polymorphic: true, touch: true, optional: true
  belongs_to :image, optional: true

  # -----------------------------------------------------------------------------
  # Instance Methods
  # -----------------------------------------------------------------------------

  def prioritizable_collection
    self.class.where(
      imageable_type: self.imageable_type,
      imageable_id: self.imageable_id,
      collection: self.collection,
    ).order("weight asc, id asc")
  end

end
