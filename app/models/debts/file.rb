class Debts::File < ActiveRecord::Base
	self.table_name_prefix = 'debt_'

	belongs_to :debt, touch: true
	belongs_to :resource
end
