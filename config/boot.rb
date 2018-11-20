ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

# Load core extensions
require File.expand_path("../../app/middleware/bad_request_handling", __FILE__)
