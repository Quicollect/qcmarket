class Debts::Status < ActiveRecord::Base
	self.table_name_prefix = 'debt_'

	extend Lookup
end
