class CreateDebtProposals < ActiveRecord::Migration
  def change
    create_table :debt_proposals do |t|
		t.string :key
      	t.integer :debt_id
      	t.integer :item_id
      	t.datetime :expires
      	t.boolean :accepted, default: false
      	t.timestamps
    end

    add_index :debt_proposals, :debt_id
    add_index :debt_proposals, :key
  end
end
