class AddAmountPaidToDebts < ActiveRecord::Migration
  def change
    add_column :debts, :amount_paid, :integer, default: 0
  end
end
