class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :title, null: false
      t.integer :naId, null: false
      t.references :record_object

      t.timestamps
    end
  end
end
