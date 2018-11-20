class CreateRedirects < ActiveRecord::Migration[5.0]
  def change
    create_table :redirects do |t|
      t.timestamps null:false
      t.text :original_path, null:false, index:true
      t.text :target_uri, null:false, index:true
      t.text :parameter_preservation_mode, null:false, default:"outgoing", index:true
    end
  end
end
