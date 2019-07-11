class CreateRecordObjects < ActiveRecord::Migration[6.0]
  def change
    create_table :record_objects do |t|
      t.string :label, null: false
      t.string :description
      t.string :attribution
      t.string :license
      t.integer :naId, null: false
      t.references :image, null: false

      t.integer :record_objectable_id, null: false, index: true
      t.string :record_objectable_type, null: false, index: true

      t.timestamps
    end
  end
end
