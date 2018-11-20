class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :documents do |t|
      t.string   "title",                 null: false
      t.string   "uuid",                  null: false
      t.string   "attachment_file_name"
      t.string   "attachment_content_type"
      t.integer  "attachment_file_size"
      t.datetime "attachment_updated_at"
      t.datetime "created_at",            null: false
      t.datetime "updated_at",            null: false
    end

    add_index :documents, :uuid, unique: true
  end
end
