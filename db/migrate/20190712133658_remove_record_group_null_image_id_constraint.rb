class RemoveRecordGroupNullImageIdConstraint < ActiveRecord::Migration[6.0]
  def change
    change_column :record_objects, :image_id, :integer, :null => true
  end
end
