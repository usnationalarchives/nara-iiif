class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      t.string   "title",                   null: false
      t.string   "alt_text",                null: false
      t.string   "caption"
      t.text     "keywords"
      t.string   "attribution"
      t.datetime "created_at",              null: false
      t.datetime "updated_at",              null: false
      t.string   "image_file_file_name"
      t.string   "image_file_content_type"
      t.integer  "image_file_file_size"
      t.datetime "image_file_updated_at"
    end
  end
end
