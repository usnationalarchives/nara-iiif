# -----------------------------------------------------------------------------
# Designateable
# Mark one model instance as the “official” one
# -----------------------------------------------------------------------------
# This concern requires that you create a boolean field on your model such that
#
#   add_column :blog_posts, :designated, :boolean, null:false, default:false, index:true
#
# Afterward, the model will allow you to mark, at most, one and only one entry as
# the designated one with
#
#   @klass.designate!
#
# Then you can find the designated model instance with:
#
#   BlogPost.designated
#
# You may also have no entires designated, by just calling undesignate! on the
# designated model
#
#   @klass.undesignate!
#
# Designation is exclusive; calling designate! will undesignate! all others first

module Designateable

  extend ActiveSupport::Concern

  class_methods do

    # Returns the designated model instance
    def designated
      if self.column_names.include?("expired_at")
        where("designated IS TRUE AND (expired_at IS NULL OR expired_at > ?)", Time.current).first
      else
        where(designated:true).first
      end
    end

  end

  def designate!
    self.class.transaction do
      self.class.where(designated:true).each do |highlander|
        highlander.undesignate!
      end
      self.designated = true
      self.save(validate:false)
    end
  end

  def undesignate!
    self.designated = false
    self.save(validate:false)
  end

end
