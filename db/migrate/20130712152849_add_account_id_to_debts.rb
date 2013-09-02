class AddAccountIdToDebts < ActiveRecord::Migration
  def change
  	add_column :debts, :account_id, :integer, default: 0
  	add_index :debts, :account_id
  end
end
