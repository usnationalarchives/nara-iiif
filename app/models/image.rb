class Image < ApplicationRecord

  default_scope {
    with_attached_image
  }

  has_one_attached :image

  belongs_to :imageable, polymorphic: true

  validates :title, presence: true
  validates :description, presence: true

end