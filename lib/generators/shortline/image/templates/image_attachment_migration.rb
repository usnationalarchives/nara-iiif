class CreateImageAttachments < ActiveRecord::Migration[5.1]
  def change
    create_table :image_attachments do |t|
      t.references :image
      t.integer :imageable_id, null: false, index: true
      t.string :imageable_type, null: false, index: true
      t.string :collection, null: false, index: true
      t.integer :weight, null: false

      t.timestamps null: false
    end
  end
end
