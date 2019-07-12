class Post < ApplicationRecord

  validates :title, presence: true
  validates :description, presence: true
  validates :body, presence: true

  default_scope {
    includes(:image)
  }

  has_one :image, as: :imageable, dependent: :destroy
  accepts_nested_attributes_for :image, allow_destroy: true, reject_if: 'all_blank'

end
