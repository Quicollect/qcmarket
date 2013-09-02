class AddResources < ActiveRecord::Migration
  def change
  	create_table :resources do |t|
  	  t.integer  :account_id
      t.string   :resource_file_name
      t.string   :resource_content_type
      t.integer  :resource_file_size
      t.timestamps
    end

    add_index :resources, :account_id
  end
end
