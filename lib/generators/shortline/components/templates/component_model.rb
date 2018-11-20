class Component < ApplicationRecord

  include CollectionPrioritizable
  include ModalAttributable
  include Publishable

  # -----------------------------------------------------------------------------
  # Scopes
  # -----------------------------------------------------------------------------

  default_scope {
    includes(
      # TODO: eager load all possible component types
      # :component_your_component_type
    )
  }


  # -----------------------------------------------------------------------------
  # Associations
  # -----------------------------------------------------------------------------

  belongs_to :componentable, polymorphic: true, touch: true

  # TODO: include has_one associations for all component types
  # has_one :component_your_component_type, dependent: :destroy

  # -----------------------------------------------------------------------------
  # Nested Attributes
  # -----------------------------------------------------------------------------

  # TODO: accept nested attributes for all component types
  # accepts_nested_attributes_for :component_your_component_type, allow_destroy: true

  # -----------------------------------------------------------------------------
  # Validations
  # -----------------------------------------------------------------------------

  validates :title, {
    presence: true
  }

  # -----------------------------------------------------------------------------
  # Modal Attributes
  # -----------------------------------------------------------------------------

  modal_attribute :component_type, {
    # TODO: define key/value pairs for all component types
    # your_component_type: "Your Component Type",
  }

  # ----------------------------------------------------------------------------
  # Instance Methods
  # ----------------------------------------------------------------------------

  def prioritizable_collection
    self.componentable.components
  end

  # -----------------------------------------------------------------------------
  # Tolaria
  # -----------------------------------------------------------------------------

  manage_with_tolaria using: {
    allowed_actions: %i[show update edit destroy],
    permit_params: [
      :title,
      :component_type,
      :status,

      # TODO: define strong parameters for all component types
      # your_component_type_attributes: [
      #   :custom_attribute_one,
      #   :custom_attribute_two,
      #   :custom_attribute_three,
      #   :id,
      #   :_destroy
      # ],
    ]
  }

end
