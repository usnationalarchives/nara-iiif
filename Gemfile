source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "2.4.1"

# CORE SYSTEM
gem "rails", "~> 5.1"
gem "tolaria", "~> 2.0"                  # The CMS framework for making your editors happy
gem "sprockets-rails", "~> 3.1"          # The Rails asset pipeline

# BASE-BUILD GEMS
gem "aws-sdk", "~> 2.3.0"                # Required for Paperclip to talk to Amazon S3
gem "bugsnag"                            # The exception collation service
gem "dalli"                              # Memcached integration
gem "dotenv-rails"                       # Slurp in .env files during rake tasks and development
gem "jbuilder", "~> 2.5"                 # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "kaminari"                           # Awesome pagination
gem "memcachier"                         # Connects Dalli to MemCachier
gem "paperclip", "~> 5.0.0"              # Uploaded asset management and thumbnail processing
gem "pg"                                 # PostgreSQL adapter
gem "puma"                               # Multi-process, thread-safe Rack server
gem "rack-cache"                         # Rack::Cache middleware
gem "redcarpet"                          # Markdown document processing
gem "secure_headers", "~> 3.0"           # CSP and other security HTTP headers
gem "seed-fu"                            # Nice fixtures
gem 'webpacker', '~> 2.0'                # Webpack module support
gem 'rack-cors'

# ASSET PIPELINE
gem "autoprefixer-rails"                 # Autoprefixer for Sprockets/Rails
gem "sass-rails", require:false          # Don’t load sass-rails (but some gems depend on it)
gem "sassc-rails"                        # SassC (libsass) for Sprockets/Rails
gem "uglifier"                           # JavaScript minifier
gem "font_assets", "~> 0.1.14"           # Sets an Access-Control-Allow-Origin header for font files

# OTHER USEFUL GEMS
# gem "faker"                            # Generates fake data in many formats
# gem "icalendar"                        # iCal/Outlook/.ics calendar files
# gem "stripe"                           # Stipe connectivity
# gem "twitter"                          # Twitter API connectivity
# gem "vcardigan"                        # vCard/.vcf exporting

# APPLICATION SPECIFIC GEMS 
gem 'riiif'

# PRODUCTION-ONLY GEMS
group :production do
  gem "rails_12factor"                   # Heroku 12-factor app support
end

# TEST SUITE GEMS
group :test do
  gem "capybara"                         # Simulates how a real user interacts with your app in your tests
  gem "factory_girl_rails"               # A fixtures replacement for testing
  gem "temping"                          # Allows creation of arbitrary ActiveRecord models and their associated DB tables for testing
end

# AUDITING OR DEVELOPMENT-ONLY GEMS
group :development do
  gem "byebug",                          # Call 'byebug' anywhere in the code to stop execution and get a debugger console
    platforms: [:mri, :mingw, :x64_mingw]
  gem "brakeman"                         # Audit the app for gems with CVEs and possibly insecure code
  gem "bullet"                           # Reporting on N+1 and unoptimized queries

  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem "web-console", ">= 3.3.0"
  gem "listen", "~> 3.0.5"

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"

  gem "letter_opener"                    # Open emails in the browser in development mode
end
