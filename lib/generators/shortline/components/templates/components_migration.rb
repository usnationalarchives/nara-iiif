class CreateComponents < ActiveRecord::Migration[5.0]
  def change
    create_table :components do |t|
      t.references :componentable, null: false, polymorphic: true
      t.integer :weight, null: false, index: true
      t.string :component_type, null: false
      t.string :status, default: "draft", null: false, index: true
      t.string :title, null: false

      t.timestamps null: false
    end
  end
end
