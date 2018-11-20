# -----------------------------------------------------------------------------
# HasCuratedCollections allows you to define related resources from various
# content types
# -----------------------------------------------------------------------------
# This concern requires the Curatable concern
#
# Modal Usage:
#
# curated_collection :feature_items , { types: ["Article", "Resource"] }
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
# <%= f.curated_collection :feature_items %>
#
module HasCuratedCollections
  extend ActiveSupport::Concern

  module ClassMethods

    def curated_collection(collection_name, options = {})
      has_many "#{collection_name}_curated_items".to_sym,
        lambda { where(collection: collection_name.to_s, resource_type: options[:types]).order("weight asc") }, {
          class_name: "CuratedItem",
          as: :parent,
          dependent: :destroy
        }

      define_method(collection_name) do
        return self.send("#{collection_name}_curated_items").map { |item| item.try(:resource) }.compact
      end

      define_singleton_method("#{collection_name}_types") do
        return options[:types]
      end

      accepts_nested_attributes_for "#{collection_name}_curated_items", allow_destroy: true

    end
  end
end
