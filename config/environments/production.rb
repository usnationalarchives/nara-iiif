Rails.application.configure do

  # --------------------------------------------------------------------------
  # PRODUCTION MODE
  # These settings put Rails in production, turning off developer assistance
  # --------------------------------------------------------------------------

  # Force all access to the app to be over SSL
  config.force_ssl = true

  # Set default TLS header and HSTS options
  config.ssl_options = {
    secure_cookies: true,
    hsts: {
      subdomains: false, # Don't include subdomains
      expires: 365.days, # Expire in one year
      preload: false, # Do not has to get added to browser preload requests
    }
  }

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both thread web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error report screens are disabled
  config.consider_all_requests_local = false

  # Do not dump schema after migrations (required for Heroku)
  # There is no use for schema.rb in production
  config.active_record.dump_schema_after_migration = false

  # --------------------------------------------------------------------------
  # ASSET PIPELINE
  # These settings control how Rails handles front-end assets in production
  # --------------------------------------------------------------------------

  # Enable serving of images, stylesheets, and JavaScripts from an asset server or a CDN
  # config.action_controller.asset_host = "https://#{ENV.fetch('FASTLY_CDN_URL')}"

  # Compress JavaScripts and CSS. Strip absolutely every comment.
  config.assets.js_compressor = Uglifier.new(copyright:false)
  config.assets.css_compressor = :sass

  # Precompile assets on server push
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # Set HTTP caching for /public assets
  config.public_file_server.headers = {
    'Cache-Control' => 'public, s-maxage=31536000, maxage=15552000',
    'Expires' => "#{1.year.from_now.to_formatted_s(:rfc822)}"
  }

  # --------------------------------------------------------------------------
  # CACHING
  # These settings turn on application-level memory caching, such as
  # Rails.cache and friends
  # --------------------------------------------------------------------------

  # Caching is turned on
  config.action_controller.perform_caching = true

  # Use Dalli for memory caching
  config.cache_store = :dalli_store

  # Create a Dalli client for Rack::Cache
  config.dalli_client = Dalli::Client.new(ENV.fetch("MEMCACHIER_SERVERS").split(","), {
    username: ENV.fetch("MEMCACHIER_USERNAME"),
    password: ENV.fetch("MEMCACHIER_PASSWORD"),
    failover: true,
    socket_timeout: 1.5,
    socket_failure_delay: 0.2,
    value_max_bytes: 10485760,
  })

  # Connect Dalli and Rack::Cache
  config.action_dispatch.rack_cache = {
    metastore: config.dalli_client,
    entitystore: config.dalli_client,
  }

end
