class RecordObject < ApplicationRecord
  # validates :attribution
  # validates :description
  validates :label, presence: true
  # validates :license
  validates :naId, presence: true

  default_scope {
    includes(:image)
  }

  has_one :image, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :image, allow_destroy: true
end
