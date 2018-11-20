class CreateMiscellany < ActiveRecord::Migration[5.0]

  create_table :miscellany, force:true do |t|
    t.string :key, null:false, index:true
    t.string :name, null:false
    t.text :description, null:false
    t.text :value
  end

end
