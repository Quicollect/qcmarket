class AgencyContract < ActiveRecord::Base
	belongs_to :agency
	has_many :debt_placements

	before_save :pre_save

	def self.active_contract(agency_id)
		AgencyContract.where(agency_id: agency_id, active: true)
	end

private
	# TODO: this is a bit of a risky approch to change the @new_record attribute but it
	# is better then to override the save method which is even more risky
	def pre_save
		# if attached to existing debt placement and content has changed duplicate it 
		if !new_record? && content_changed? && Debts::Placement.where(agency_contract_id: self.id).length > 0
			@new_record = true
			self.id = nil
			self.created_at = nil
			self.updated_at = nil
			self.agency_id_will_change!
			self.active_will_change!
		end
		
		# deactivate old contracts
		if new_record?
			contracts = AgencyContract.active_contract(self.agency_id)
			contracts.each do | contract |
				contract.attributes = {active: false}
				contract.save
			end
			
			# ensure we are now the active one
			self.active = true
		end
	end
end
