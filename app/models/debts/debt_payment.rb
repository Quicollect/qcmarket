module Debts
	class DebtPayment < ActiveRecord::Base
		belongs_to :debt, touch: true
		
		monetize :amount_cents, with_model_currency: :amount_currency
	end
end
