class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.text :title, null: false
      t.text :description, null: false
      t.text :body, null: false
      t.datetime :published_at, null: false
      t.string :status, null: false, default: "draft"
      t.text :uuid, null: false
      t.tsvector :search_vector

      t.timestamps null: false

      t.index :search_vector, using: :gin
    end
  end
end

