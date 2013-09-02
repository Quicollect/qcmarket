class AddAccountIdToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :account_id, :integer, :null => false
  	add_index :users, :account_id
  end
end
