# -----------------------------------------------------------------------------
# Prioritizable
# Keep your models in an arbitrary order
# -----------------------------------------------------------------------------
# This concern requires that you create a field on your model such that
#
#   add_column :blog_posts, :priority, :integer, null:false, index:true
#
# Afterward, the models will maintain a manual prioritization order
# than can be changed by you or admin users via move_up! and move_down!
# causing items to re-order themselves one step up/down a time
#
# You can get the models in prioritized order via
#
#   Klass.prioritized
#
# And you can inspect the current ordering of an item with
#
#  @klass.priority_placement
#

module Prioritizable

  extend ActiveSupport::Concern

  included do

    before_validation :initialize_priority!

    scope :prioritized, lambda {
      order("priority ASC")
    }

    validates :priority, {
      uniqueness: true,
      numericality: {
        only_interger: true,
        greater_than_or_equal_to: 0,
      }
    }

  end

  def initialize_priority!
    if self.respond_to?(:priority=)
      self.priority ||= ((self.class.maximum("priority") || 0) + 2)
    end
  end

  def move_up!

    resources = self.class.prioritized
    index = resources.find_index(self)

    return false if index.zero? # already on top

    other_resource = resources[index - 1]
    swap_priority_with_other_resource!(other_resource)
    return true

  end

  def move_down!

    resources = self.class.prioritized
    index = resources.find_index(self)

    return false if index == (resources.size - 1) # already on bottom

    other_resource = resources[index + 1]
    swap_priority_with_other_resource!(other_resource)
    return true

  end

  def priority_placement
    resources = self.class.prioritized
    index = resources.find_index(self)
    if resources.size.eql? 1
      "lonely".inquiry
    elsif index.zero?
      "top".inquiry
    elsif index == (resources.size - 1)
      "bottom".inquiry
    else
      "middle".inquiry
    end
  end

  protected

  def swap_priority_with_other_resource!(other_resource)

    self.priority, other_resource.priority = other_resource.priority, self.priority

    self.class.transaction do
      self.save(validate:false)
      other_resource.save(validate:false)
    end

  end

end
