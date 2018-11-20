class CuratedItem < ApplicationRecord

  include CollectionPrioritizable

  # -----------------------------------------------------------------------------
  # Associations
  # -----------------------------------------------------------------------------

  belongs_to :parent, polymorphic: true, touch: true
  belongs_to :resource, polymorphic: true

  # -----------------------------------------------------------------------------
  # Validations
  # -----------------------------------------------------------------------------

  # Removed to allow model updates without assiging a featured resource
  # validates :parent_id, presence: true
  # validates :parent_type, presence: true
  # validates :resource_id, presence: true
  # validates :resource_type, presence: true

  # -----------------------------------------------------------------------------
  # Instance Methods
  # -----------------------------------------------------------------------------

  def prioritizable_collection
    self.class.where(
      parent_type: self.parent_type,
      parent_id: self.parent_id,
      collection: self.collection,
    ).order("weight asc, id asc")
  end

end
