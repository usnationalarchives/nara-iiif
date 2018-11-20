# --------------------------------------------------------------------------------
# GloballyCacheable provides a re-usable request caching-system
# --------------------------------------------------------------------------------
# If your controller includes GloballyCacheable, you can then call
# `globally_cache!` inside a `before_filter` or inside a controller method
# body to cause that entire response to be cached by the Rails app for ten minutes.
#
# GloballyCachable automatically busts itself when the Rails cache is cleared
# (ex. by SiteSweeper) or when a new scheduled model is slated to go live
#
# This concern is included in the ApplicationController and doesnt need to be
# included on individual resource controllers

module Application::GloballyCacheable

  extend ActiveSupport::Concern

  def globally_cache!
    if Rails.env.production?
      expires_in 10.minutes
      fresh_when etag: [global_etag_key, scheduled_publishing_key].compact.max, public: true
    end
  end

  # ---------------------------------------------------------------------------
  # Generate and cache a global etag key on the following request after the
  # site sweeper clears the entire Rails cache.
  # ---------------------------------------------------------------------------

  protected

  def global_etag_key
    Rails.cache.fetch("global_etag_key") do
      Time.current.to_i
    end
  end

  def scheduled_publishing_key

    schedulable_models = Rails.cache.fetch("scheduleable_models") do
      ActiveRecord::Base.descendants.select do |klass|
        klass.included_modules.include?(Publishable) and klass.try(:attribute_names).try(:include? , "published_at")
      end
    end

    keys = schedulable_models.map { |m| m.published.maximum(:published_at).try(:to_time).try(:to_i) }
    keys.compact.max

  end

end

