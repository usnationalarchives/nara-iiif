require "rails/generators"
require "rails/generators/migration"
require "rails/generators/active_record"

module Shortline

  class ComponentsGenerator < ::Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path("../templates", __FILE__)

    def self.next_migration_number(dirname)
      ActiveRecord::Generators::Base.next_migration_number(dirname)
    end

    def install
      copy_file "admin_components_controller.rb", "app/controllers/admin/components_controller.rb"
      copy_file "component_model.rb", "app/models/component.rb"
      copy_file "componentable_concern.rb", "app/models/concerns/componentable.rb"
      migration_template "components_migration.rb", "db/migrate/create_components.rb"

      copy_file "views/admin/components/_form.html.erb", "app/views/admin/components/_form.html.erb"
      copy_file "views/shared/_components.html.erb", "app/views/shared/_components.html.erb"

      puts "You will need to do the following manually:"
      puts ""
      puts "1. Define component types by creating their required models, form field partials, database tables, and adding relevant additions to the Component model"
      puts "2. Add the Componentable concern to relevant models"
      puts "3. Update admin forms to support adding multiple components with the f.has_many formbuilder helper"
      puts "4. Render the app/views/admin/shared/_components_table.html.erb partial on relevant admin inspect views"
      puts "5. Add :components to the collection prioritizable items in config/routes.rb"
    end
  end
end
