class Debts::Placement < ActiveRecord::Base
	self.table_name_prefix = 'debt_'

	belongs_to :debt, class_name: "Debt", touch: true
	belongs_to :agency
	belongs_to :price_model

	has_many :debt_payments, class_name: "Debts::Payment"
	has_one :review, foreign_key: :debt_placement_id
	has_one :agency_contract
end