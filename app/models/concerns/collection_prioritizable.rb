# -----------------------------------------------------------------------------
# Collection Prioritizable keeps models in an arbitrary order inside a specific
# collection such as a set of slides that all "belong to" a certain section
# -----------------------------------------------------------------------------
# This concern requires that you create a field on your
# model such that
#
#   t.integer :weight, null:false
#
# This concern also requires you to define a method called
# "prioritizable_collection" on the model:
#
#   def prioritizable_collection
#     self.parent_item.sibling_items
#   end
#
# This concern allows you to call move_up_in_collection! or move_down_in_collection!
# to move an item up or down inside the collection returned by the
# prioritizable_collection method on the model.

module CollectionPrioritizable

  extend ActiveSupport::Concern

  included do

    # ---------------------------------------------------------------------------
    # Callbacks
    # ---------------------------------------------------------------------------

    before_create :init_weight
    after_update :address_weight_conflicts

    # ---------------------------------------------------------------------------
    # Instance Methods
    # ---------------------------------------------------------------------------

    def move_up_in_collection!
      weight = self.weight

      if previous_item = self.prioritizable_collection.where(['weight < ?', weight]).last
        swap_weight_with_other_item!(previous_item)
      end
    end

    def move_down_in_collection!
      weight = self.weight

      if next_item = self.prioritizable_collection.where(['weight > ?', weight]).first
        swap_weight_with_other_item!(next_item)
      end
    end

    # ---------------------------------------------------------------------------
    # Private Methods
    # ---------------------------------------------------------------------------

    private

      def swap_weight_with_other_item!(other_item)
        other_weight = other_item.weight
        self_weight = self.weight

        self.update_columns(weight: other_weight)
        other_item.update_columns(weight: self_weight)
      end

      def init_weight
        collection = self.prioritizable_collection
        collection.any? ? self.weight = collection.maximum(:weight) + 2 : self.weight = 2
      end

      # ---------------------------------------------------------------------------
      # ADDRESS WEIGHT CONFLICTS:
      # Corrects any conflicts in duplicate weights when assigning a record to a
      # new parent item on update.
      # ---------------------------------------------------------------------------

      def address_weight_conflicts
        if self.prioritizable_collection.where(weight: self.weight).count > 1
          self.update_columns(weight: self.prioritizable_collection.maximum(:weight) + 2)
        end
      end
  end
end
