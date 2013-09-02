class AddDeletedFlagToDebts < ActiveRecord::Migration
  def change
    add_column :debts, :deleted, :boolean, default: false
  end
end
