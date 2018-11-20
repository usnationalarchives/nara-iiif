ENV["RAILS_ENV"] ||= "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "capybara/rails"
require "minitest/pride"

# Force ActiveRecord to not log anything
ActiveRecord::Base.logger = nil

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!
  # Include FactoryGirl helper methods
  include FactoryGirl::Syntax::Methods
end

class ActionDispatch::IntegrationTest
  # Include the Rails route helpers
  include Rails.application.routes.url_helpers
end
