class Article < ApplicationRecord

  include EditorialSluggable
  include FulltextSearchable
  include Publishable
  include UniquelyIdentifiable

  has_fulltext_search plan: {
    A: [:title],
    B: [:description],
    C: [:body]
  }

  # -----------------------------------------------------------------------------
  # Validations
  # -----------------------------------------------------------------------------

  validates :title, presence: true
  validates :description, presence: true
  validates :body, presence: true

  # -----------------------------------------------------------------------------
  # Tolaria
  # -----------------------------------------------------------------------------

  manage_with_tolaria using: {
    icon: "edit",
    category: "Syndication",
    priority: 1,
    default_order: "published_at desc",
    paginated: true,
    permit_params: [
      :title,
      :subtitle,
      :description,
      :body,
      :status,
      :published_at,
    ]
  }

end
