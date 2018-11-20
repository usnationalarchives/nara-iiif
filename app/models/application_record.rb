class ApplicationRecord < ActiveRecord::Base

  self.abstract_class = true

  # --------------------------------------------------------------------------
  # CACHE CLEARING
  # --------------------------------------------------------------------------
  # Saving or deleting instances of subclasses of ApplicationRecord
  # will bust your entire Rails site cache.
  # This ensures that saving anything in the CMS causes pages to refresh.
  # If you want to stop this behavior on your subclass,
  # set `self.skips_cache_clearing = true` in the class definition.
  # --------------------------------------------------------------------------

  def self.skips_cache_clearing=(new_clearing_value)
    @skips_cache_clearing = new_clearing_value
  end

  def self.skips_cache_clearing?
    !!(defined?(@skips_cache_clearing) && @skips_cache_clearing == true)
  end

  after_save :clear_rails_cache!, unless: lambda { self.class.skips_cache_clearing? }
  after_destroy :clear_rails_cache!, unless: lambda { self.class.skips_cache_clearing? }

  def clear_rails_cache!
    # puts "Rails cache cleared"
    Rails.cache.clear
  end

end
