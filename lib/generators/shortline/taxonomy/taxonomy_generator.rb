require "rails/generators"
require "rails/generators/migration"
require "rails/generators/active_record"

module Shortline
  class TaxonomyGenerator < ::Rails::Generators::NamedBase
    include Rails::Generators::Migration
    source_root File.expand_path("../templates", __FILE__)

    def self.next_migration_number(dirname)
      ActiveRecord::Generators::Base.next_migration_number(dirname)
    end

    def install
      # Model
      copy_file "taxomony_model.rb", "app/models/#{file_name}.rb"
      gsub_file "./app/models/#{file_name}.rb", '$Taxomony', "#{class_name}"

      #Concerns
      directory "concerns", "app/models/concerns"

      # Admin Views
      directory "views", "app/views/admin/#{plural_file_name}"
      gsub_file "./app/views/admin/#{plural_file_name}/_form.html.erb", 'taxonomy', "#{human_name.downcase}"

      # Migration
      migration_template "taxomony_migration.rb", "db/migrate/create_#{plural_file_name}.rb"
    end
  end
end
