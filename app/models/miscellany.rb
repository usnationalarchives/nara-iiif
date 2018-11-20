class Miscellany < ApplicationRecord

  self.table_name = :miscellany

  # ---------------------------------------------------------------------------
  # VALIDATION
  # ---------------------------------------------------------------------------

  validates_presence_of :description
  validates_presence_of :key
  validates_presence_of :name
  validates_presence_of :value

  validates_uniqueness_of :key
  validates_uniqueness_of :name

  # ---------------------------------------------------------------------------
  # TOLARIA
  # ---------------------------------------------------------------------------

  manage_with_tolaria using: {
    allowed_actions: [:index, :show, :edit, :update],
    icon: "cogs",
    category: "Settings",
    priority: 1,
    permit_params: [
      :value
    ]
  }


end
