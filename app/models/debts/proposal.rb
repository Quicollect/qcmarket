class Debts::Proposal < ActiveRecord::Base
	self.table_name_prefix = 'debt_'

	belongs_to :shoppinglist_item, class_name: "Debts::ShoppinglistItem", foreign_key: :item_id

	before_save do
		@item = self.shoppinglist_item
		@item.update!(shoppinglist_item_status_id: self.accepted ? 
			Debts::ShoppinglistItemStatus.lookup(:accepted) : 
			Debts::ShoppinglistItemStatus.lookup(:contacted))
	end
end
