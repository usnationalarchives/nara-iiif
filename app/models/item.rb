class Item < ApplicationRecord
  validates :title, presence: true
  validates :naId, presence: true
  validates :body, presence: true

  default_scope {
    includes(:image)
  }

  has_many :record_objects, as: :record_objectable, dependent: :destroy
  accepts_nested_attributes_for :record_objects, reject_if: :all_blank, allow_destroy: true  
  # accepts_nested_attributes_for :image, allow_destroy: true  
end
