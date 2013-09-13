class CreateShoppinglistItemStatuses < ActiveRecord::Migration
  def change
    create_table :shoppinglist_item_statuses do |t|
    	t.string :name
      	t.timestamps
    end

    add_column :debt_shoppinglist_items, :shoppinglist_item_status_id, :integer
  end
end
