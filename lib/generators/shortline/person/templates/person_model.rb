class Person < ApplicationRecord

  include AutoSluggable
  include FulltextSearchable

  has_fulltext_search plan: {
    A: [:name],
    B: [:title],
    C: [:bio]
  }

  # -----------------------------------------------------------------------------
  # Validations
  # -----------------------------------------------------------------------------

  validates :name, presence: true, uniqueness: true
  validates :title, presence: true
  validates :bio, presence: true

  # -----------------------------------------------------------------------------
  # Tolaria
  # -----------------------------------------------------------------------------

  manage_with_tolaria using: {
    icon: "user",
    category: "People",
    priority: 1,
    default_order: "created_at desc",
    paginated: true,
    permit_params: [
      :name,
      :title,
      :bio,
    ]
  }

end
