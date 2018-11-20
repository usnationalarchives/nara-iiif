require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Shortline
  class Application < Rails::Application

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # --------------------------------------------------------------------------
    # SECRET KEY BASE
    # This secret string is used to sign sessions and cookies for your application.
    # Changing it will invalidate all current sessions.
    # The secret should be at least 32 completely random characters.
    # --------------------------------------------------------------------------

    # Load the secret key from the environment.
    config.secret_key_base = ENV.fetch("SECRET_KEY_BASE")

    # --------------------------------------------------------------------------
    # ASSET PIPELINE
    # These settings control how Rails handles front-end assets
    # --------------------------------------------------------------------------

    # Use SassC (libsass) instead of Ruby Sass
    config.assets.register_engine ".sass", SassC::Rails::SassTemplate
    config.assets.register_engine ".scss", SassC::Rails::ScssTemplate

    # Don’t output per-line Sass/CSS comments.
    config.sass.line_comments = false

    # Serve all files in /public with cache headers
    config.public_file_server.enabled = true
    config.public_file_server.headers = { "Cache-Control" => "public, max-age=172800" }

    # The Rails asset version is a fingerprint of the current app/assets files
    config.assets.version = begin
      files = Dir["#{Rails.root}/app/assets/**/*"].reject{|f| File.directory?(f)}.sort
      content = files.map{|f| File.read(f)}.join
      Digest::MD5.hexdigest(content)
    end

    # ------------------------------------------------------------------------
    # RACK
    # These settings control middleware that Rails uses and how it behaves
    # ------------------------------------------------------------------------

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation, :body]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # We don't need to trace request IDs (X-Request-Id header)
    config.middleware.delete ::ActionDispatch::RequestId

    # Don't set X-Runtime, we don't care, we have real app metrics
    # This header is also a potential venue for timing attacks
    # https://github.com/rails/rails/issues/16433
    config.middleware.delete ::Rack::Runtime

    # Serve all assets and pages with gzip compression
    config.middleware.insert_before ::ActionDispatch::Static, Rack::Deflater

    # Use the UTF-8 error middleware
    # app/middleware/bad_request_handling.rb
    config.middleware.use ::BadRequestHandling

    # Disable ActionDispatch::BestStandardsSupport so we can set the header ourselves
    config.action_dispatch.best_standards_support = false

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

    # --------------------------------------------------------------------------
    # LOGGING
    # We send everything to STDOUT instead of log/development.log
    # --------------------------------------------------------------------------

    # Don't buffer STDOUT, print it immediately (required for Foreman/Heroku)
    STDOUT.sync = true
    logger = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)

    # See everything in the log
    config.log_level = :debug

    # Deprecation notices become exceptions. Don’t keep deprecated code!
    config.active_support.deprecation = :raise

    # ------------------------------------------------------------------------
    # MODELS AND DATABASE FORMAT
    # ------------------------------------------------------------------------

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

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

  end
end
