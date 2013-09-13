class RenameShoppinglistItemStatuses < ActiveRecord::Migration
  def change
  	rename_table :shoppinglist_item_statuses, :debt_shoppinglist_item_statuses
  end
end
