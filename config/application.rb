require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NaraIiif
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

  # Use a different logger for distributed setups.
  # require 'syslog/logger'
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end


    # Load the secret key from the environment.
    config.secret_key_base = ENV.fetch("SECRET_KEY_BASE")

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # If you want to protect the site with HTTP Basic Auth, simply
    # define HTTP_USERNAME and HTTP_PASSWORD in the relevant environment
    # You shouldn't have to change this code below
    if ENV["HTTP_USERNAME"].present? && ENV["HTTP_PASSWORD"].present?
      config.middleware.insert_before(::Rack::MethodOverride, ::Rack::Auth::Basic, "Restricted Site") do |username, password|
        [username, password] == [
          ENV.fetch("HTTP_USERNAME"),
          ENV.fetch("HTTP_PASSWORD")
        ]
      end
    end

    # ------------------------------------------------------------------------
    # TIMEZONE AND INTERNATIONALIZATION
    # ------------------------------------------------------------------------

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = "UTC"

    # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
    # the I18n.default_locale when a translation can not be found)
    config.i18n.fallbacks = true

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :en

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :options]
      end
    end
    
  end
end
