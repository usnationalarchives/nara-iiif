class <%= migration_class_name %> < ActiveRecord::Migration[5.0]
  def change
    create_table :<%= migration_file_name.gsub('create_', '').to_sym %> do |t|
      t.string :name, null: false
      t.string :slug, null: false

      t.timestamps null: false

      t.index :slug, unique: true
    end
  end
end
