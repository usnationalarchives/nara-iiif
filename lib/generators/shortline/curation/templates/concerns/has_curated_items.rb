# -----------------------------------------------------------------------------
# HasCuratedItems allows you to define related resource from various content
# types
# -----------------------------------------------------------------------------
# This concern requires the Curatable concern
#
# Modal Usage:
#
# curated_item :feature_item , { types: ["Article", "Resource"] }
# ...
# manage_with_tolaria using: {
#   permit_params: [
#     feature_items_curated_items_attributes: [
#       :_destroy,
#       :id,
#       :resource_type,
#       :resource_id
#     ]
#   ]
# }
#
# Admin Form Usage:
#
# <%= f.curated_item :feature_item %>
#

module HasCuratedItems
  extend ActiveSupport::Concern

  module ClassMethods

    def curated_item(item_name, options = {})
      has_one "#{item_name}_curated_item".to_sym,
        lambda { where(collection: item_name.to_s, resource_type: options[:types]).order("weight asc") }, {
          class_name: "CuratedItem",
          as: :parent,
          dependent: :destroy
        }

      define_method(item_name) do
        return self.send("#{item_name}_curated_item").try(:resource)
      end

      define_singleton_method("#{item_name}_types") do
        return options[:types]
      end

      accepts_nested_attributes_for "#{item_name}_curated_item", allow_destroy: true

    end
  end
end
