class CreateCuratedItems < ActiveRecord::Migration[5.0]
  def change
    create_table :curated_items do |t|
      t.string   "parent_type",   null: false
      t.integer  "parent_id",     null: false
      t.string   "resource_type", null: false
      t.integer  "resource_id",   null: false
      t.integer  "weight",        null: false
      t.string   "collection",    null: false
      t.datetime "created_at",    null: false
      t.datetime "updated_at",    null: false
    end
  end
end
