# -----------------------------------------------------------------------------
# Componentable
# -----------------------------------------------------------------------------

module Componentable

  extend ActiveSupport::Concern

  included do

    # ---------------------------------------------------------------------------
    # Associations
    # ---------------------------------------------------------------------------

    has_many :components,
      lambda { order "weight asc"}, {
        as: :componentable,
        dependent: :destroy
      }

    # ---------------------------------------------------------------------------
    # Nested Attributes
    # ---------------------------------------------------------------------------

    accepts_nested_attributes_for :components, allow_destroy: true

  end

end
