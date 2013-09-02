module Debts
	class DebtFile < ActiveRecord::Base
		belongs_to :debt, touch: true
		belongs_to :resource
	end
end