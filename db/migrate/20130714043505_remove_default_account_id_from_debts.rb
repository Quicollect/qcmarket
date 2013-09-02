class RemoveDefaultAccountIdFromDebts < ActiveRecord::Migration
  def change
  	change_column_default(:debts, :account_id, nil)
  end
end
