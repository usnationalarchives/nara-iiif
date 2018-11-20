class $Taxomony < ApplicationRecord

  include AutoSluggable

  # -----------------------------------------------------------------------------
  # Validations
  # -----------------------------------------------------------------------------

  validates :name, presence: true, uniqueness: true

  # -----------------------------------------------------------------------------
  # Tolaria
  # -----------------------------------------------------------------------------

  manage_with_tolaria using: {
    icon: "bullhorn",
    category: "Taxonomy",
    priority: 2,
    default_order: "name asc",
    paginated: true,
    permit_params: [
      :name
    ]
  }

end
