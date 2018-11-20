require "rails/generators"
require "rails/generators/migration"
require "rails/generators/active_record"

module Shortline
  class CurationGenerator < ::Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path("../templates", __FILE__)

    def self.next_migration_number(dirname)
      ActiveRecord::Generators::Base.next_migration_number(dirname)
    end

    def install
      # Model
      copy_file "curated_item_model.rb", "app/models/curated_item.rb"

      # Concerns
      directory "concerns", "app/models/concerns"

      # Admin Views
      directory "views", "app/views/admin/shared/forms"

      # Styles
      directory "stylesheets", "app/assets/stylesheets/admin/views/fields"

      # Javascripts
      # Copy Files
      directory "javascripts", "app/assets/javascripts/admin/views/fields"
      # Append Magic Comment to include script
      append_file "./app/assets/javascripts/admin/admin.js", '//= require admin/views/fields/curated_item'

      # Migration
      migration_template "curated_item_migration.rb", "db/migrate/create_curated_items.rb"

      # Initializers
      inject_into_file './config/initializers/tolaria_form_builder.rb', verbose: true, after: "  module FormBuildable\n" do
%(
    def curated_collection(collection)
      render(partial:"admin/shared/forms/curated_collection", locals: {
        f: self,
        collection: collection
      })
    end

    def curated_item(item, label_attribute:nil)
      render(partial:"admin/shared/forms/curated_item", locals: {
        f: self,
        item: item,
      })
    end
)
      end
    end
  end
end
