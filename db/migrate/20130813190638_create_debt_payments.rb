class CreateDebtPayments < ActiveRecord::Migration
  def change
    create_table :debt_payments do |t|
		t.integer :debt_placement_id
    t.integer :debt_id
		t.float :amount
		t.date :payment_date
		t.text :description
    t.timestamps
    end

    add_index :debt_payments, :debt_id
    add_index :debt_payments, :debt_placement_id
  end
end
