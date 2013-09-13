class Debts::Payment < ActiveRecord::Base
	self.table_name_prefix = 'debt_'

	belongs_to :debt, touch: true
	
	monetize :amount_cents, with_model_currency: :amount_currency
end
