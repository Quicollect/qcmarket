class Debts::Type < ActiveRecord::Base
	self.table_name_prefix = 'debt_'

	extend Lookup
	
	has_many :debts
	has_many :agency_services
	has_and_belongs_to_many :price_model
end
