class CreateDebtPlacements < ActiveRecord::Migration
  def change
    create_table :debt_placements do |t|
		t.integer :debt_id
		t.integer :account_id
		t.integer :price_model_id
		t.boolean :active
      	t.timestamps
    end

    add_index :debt_placements, [:debt_id]
    add_index :debt_placements, [:price_model_id]
    add_index :debt_placements, [:account_id]
  end
end
