Bugsnag.configure do |config|

  # The project-specific API key
  config.api_key = ENV.fetch("BUGSNAG_API_KEY")

  # This is Rails app
  config.app_type = "rails"

  # Only log production exceptions
  config.notify_release_stages = ["production"]

  # Transmit information about the Rack environment. If your app captures PCI or personal
  # information in the Rack environment, set this to `false`
  config.send_environment = true

  # Bugsnag transfers information over SSL, do not set this to `false`
  config.use_ssl = true

end
