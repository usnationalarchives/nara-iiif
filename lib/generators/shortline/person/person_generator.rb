require "rails/generators"
require "rails/generators/active_record"

module Shortline
  class PersonGenerator < ::Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path("../templates", __FILE__)

    def install

      # Model
      copy_file "person_model.rb", "app/models/person.rb"

      # Concerns
      directory "concerns", "app/models/concerns"

      # Admin Views
      directory "views", "app/views/admin/people"

      # Migration
      migration_template "people_migration.rb", "db/migrate/create_people.rb"

      puts ""
      puts "Create controller/view by running:"
      puts "rails g controller person show --no-helper --no-assets --skip-routes --no-test-framework"
      puts "and remember to update the routes. ex:"
      puts %{get "people/:slug", to: "people#show", as: "person"}
    end

    def self.next_migration_number(dirname)
      ActiveRecord::Generators::Base.next_migration_number(dirname)
    end
  end
end
