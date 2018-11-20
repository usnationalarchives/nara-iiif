class CreatePeople < ActiveRecord::Migration[5.0]
  def change
    create_table :people do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :title, null: false
      t.text :bio, null: false
      t.tsvector :search_vector

      t.timestamps null: false

      t.index :slug, unique: true
      t.index :search_vector, using: :gin
    end
  end
end
