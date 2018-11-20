# -----------------------------------------------------------------------------
# Publishable
# Add a publishing workflow to your model
# -----------------------------------------------------------------------------
# This concern requires that you create a text column on your model
#
#   add_column :blog_posts, :text, :status, null:false, default:"draft"
#
# You may optionally also add a publishing time to the model
#
#   add_column :blog_posts, :published_at, :timestamp, null:false
#
# And if you added a publishing time, you may optionally add an expiration date
#
#   add_column :blog_posts, :expired_at, :timestamp, null:false
#
# You can then track the publishing status of each instance with
#
#   @klass.meta_status
#
# And find models by status with
#
#   Klass.draft
#   Klass.published
#
# If you added published_at to the model, then you can also find
# syndicated items by date:
#
#   Klass.published.latest.limit(5)
#
# The publishing flow is as follows:
#
# 1. Draft items are always draft when their status.draft?
# 2. Items are published when their status.published?
# 3. If you added published_at to the model then
#    items are not published until their flag is set and then
#    the published_at date has passed. They are meta_status.scheduled? until then
# 4. If you added expired_at to the model then items are also additionally
#    unpublished after their expiration date passes and their meta_status.expired?
#    They will also not be returned by Klass.published

module Publishable

  include ModalAttributable
  extend ActiveSupport::Concern

  included do

    modal_attribute :status, {
      draft: "Draft",
      published: "Published",
    }

    if self.table_exists?

      if self.column_names.include?("expired_at")
        scope :published, lambda {
          where("status = 'published' AND published_at <= ? AND (expired_at IS NULL OR expired_at > ?)", Time.current, Time.current)
        }
      elsif self.column_names.include?("published_at")
        scope :published, lambda {
          where("status = 'published' AND published_at <= ?", Time.current)
        }
      else
        scope :published, lambda {
          where("status = 'published'")
        }
      end

      if self.column_names.include?("published_at")

        after_initialize :initalize_published_at!

        scope :latest, lambda {
          order("published_at DESC")
        }

        validates :published_at, {
          presence: true,
        }

      end

    end

    scope :draft, lambda {
      where(status:"draft")
    }

  end

  def initalize_published_at!
    if self.respond_to?(:published_at=)
      self.published_at ||= Time.current
    end
  end

  def meta_status
    return "draft".inquiry if self[:status] == "draft"
    return "expired".inquiry if defined?(expired_at) && expired_at.present? && expired_at < Time.current
    if self[:status].eql?("published")
      if self.class.column_names.include?("published_at")
        return "scheduled".inquiry if published_at > Time.current
        return "published".inquiry if published_at <= Time.current
      else
        return "published".inquiry
      end
    else
      raise RangeError, "publishable status is undefined"
    end
  end

  def draft?
    status.eql? "draft"
  end

end
