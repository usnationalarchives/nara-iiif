class RemoveImageableNullConstraint < ActiveRecord::Migration[6.0]
  def change
    change_column :images, :imageable_id, :integer, :null => true
    change_column :images, :imageable_type, :string, :null => true
  end
end
