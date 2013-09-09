class CreateDebtShoppinglistItems < ActiveRecord::Migration
  def change
    create_table :debt_shoppinglist_items do |t|
	  t.integer :account_id
	  t.integer :debt_id
	  t.integer :agency_id
	  t.text :description
      t.timestamps
    end

    add_index :debt_shoppinglist_items, :debt_id
    add_index :debt_shoppinglist_items, :account_id
  end
end
