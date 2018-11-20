require "rails/generators"
require "rails/generators/migration"
require "rails/generators/active_record"

module Shortline
  class ImageGenerator < ::Rails::Generators::Base
    include Rails::Generators::Migration
    source_root File.expand_path("../templates", __FILE__)

    def self.next_migration_number(dirname)
      ActiveRecord::Generators::Base.next_migration_number(dirname)
    end

    def install
      # Model
      copy_file "image_model.rb", "app/models/image.rb"
      copy_file "image_attachment_model.rb", "app/models/image_attachment.rb"

      # Concerns
      directory "concerns", "app/models/concerns"

      # Admin Views
      directory "views", "app/views"

      # Migration
      migration_template "image_migration.rb", "db/migrate/create_images.rb"
      migration_template "image_attachment_migration.rb", "db/migrate/create_image_attachments.rb"

      inject_into_file './config/initializers/tolaria_form_builder.rb', verbose: true, after: "  module FormBuildable\n" do
%{

    def image(image, hint: nil)
      render(partial:"admin/shared/forms/image_attachment", locals: {
        f: self,
        image_attachment: "\#{image}_image_attachment".to_sym,
        hint: hint.present?? hint : "Select an image."
      })
    end

}
      end

      inject_into_file './app/helpers/shortcode_helper.rb', verbose: true, after: "  \# Project-specific Shortcodes\n" do
%{
  register_shortcode "image" do |*args|
    image = Image.find_by_id(args.first.to_i)
    return nil unless image
    render partial:"shared/shortcodes/image", locals: {
      image: image,
      caption: args.second.presence
    }
  end

  register_shortcode "image-left" do |*args|
    image = Image.find_by_id(args.first.to_i)
    return nil unless image
    render partial:"shared/shortcodes/image", locals: {
      position: "left",
      image: image,
      caption: args.second.presence
    }
  end

  register_shortcode "image-right" do |*args|
    image = Image.find_by_id(args.first.to_i)
    return nil unless image
    render partial:"shared/shortcodes/image", locals: {
      position: "right",
      image: image,
      caption: args.second.presence
    }
  end
}
      end
    end
  end
end
