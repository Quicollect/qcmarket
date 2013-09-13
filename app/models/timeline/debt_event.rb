module Timeline
	class DebtEvent < Timeline::Event

		belongs_to :debt, class_name: 'Debt', touch: true
		
		# this allows us to connect it to the debt (for the touch operation)
		def debt_id
			 # TODO: filter only debt type events
			self.entity_id
		end

		scope :viewable,  lambda { | current_user |
		    if (current_user.is_admin?)
		      DebtEvent.all
		    else
		      # TODO: filter only debt type events
		      DebtEvent.joins('inner join debts on debts.id = events.entity_id inner join debt_placements on debts.id = debt_placements.debt_id').
		        where("debts.account_id = #{current_user.account_id} or (debt_placements.agency_id = #{current_user.account_id} and private = false)").
		        where(debts: {deleted: false})
		    end
		  }
	end
end