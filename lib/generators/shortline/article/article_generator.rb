require "rails/generators"
require "rails/generators/migration"
require "rails/generators/active_record"

module Shortline
  class ArticleGenerator < ::Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path("../templates", __FILE__)

    def self.next_migration_number(dirname)
      ActiveRecord::Generators::Base.next_migration_number(dirname)
    end

    def install
      copy_file "article_model.rb", "app/models/article.rb"
      directory "views", "app/views/admin/articles"
      migration_template "article_migration.rb", "db/migrate/create_articles.rb"

      puts ""
      puts "Create controller/view by running:"
      puts "rails g controller articles show --no-helper --no-assets --skip-routes --no-test-framework"
      puts "and remember to update the routes. ex:"
      puts %{get "articles/:slug", to: "articles#show", as: "article"}
      puts %{get "articles/:uuid/preview", to: "articles#preview", as: "preview_article"}
    end
  end
end
