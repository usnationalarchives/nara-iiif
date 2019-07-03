class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.integer :imageable_id, null: false, index: true
      t.string :imageable_type, null: false, index: true
    end
  end
end
