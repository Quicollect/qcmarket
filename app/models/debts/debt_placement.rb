module Debts
	class DebtPlacement < ActiveRecord::Base
		belongs_to :debt, class_name: "Debts::Debt", touch: true
		belongs_to :agency
		belongs_to :price_model

		has_many :debt_payments, class_name: "Debts::DebtPayment"
		has_one :review
		has_one :agency_contract
	end
end