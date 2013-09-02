class MergeAgenciesToAccounts < ActiveRecord::Migration
  def change
  	drop_table :agencies

  	add_column :accounts, :verified, :boolean, default: false
  	remove_column :accounts, :accountable_id, :integer 
  end
end
