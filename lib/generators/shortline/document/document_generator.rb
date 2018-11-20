require "rails/generators"
require "rails/generators/migration"
require "rails/generators/active_record"

module Shortline
  class DocumentGenerator < ::Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path("../templates", __FILE__)

    def self.next_migration_number(dirname)
      ActiveRecord::Generators::Base.next_migration_number(dirname)
    end

    def install
      copy_file "document_model.rb", "app/models/document.rb"
      directory "views", "app/views/admin/documents"
      migration_template "document_migration.rb", "db/migrate/create_documents.rb"
      route %{get "documents/:id", to: "documents#download", as: "document"\n\n}
    end
  end
end
