module DebtsHelper

	def sym_status_to_glyphicon(sym)
		case sym
			when :draft
				"notes_2"
			when :assigned
				"message_flag"
			when :accepted
				"check"
			when :rejected		
				"ban"
			when :deleted
				"remove_2"
			when :resolved
				"ok"
			when :closed
				"certificate"
			when :inforequired
				"warning_sign"
			else
				""
		end
	end

	def status_to_glyphicon(status)
		sym_status_to_glyphicon(Debts::DebtStatus.symbol(status))
	end 

	def event_to_glyphicon(event)
		symbol = Timeline::EventType.symbol(event.event_type)
		case symbol
			when :creation
				"power"
			when :update
				"edit"
			when :statuschange
				"pushpin"
			when :userevent
				"comments"
			when :delete
				"remove"
			else
				""
		end 
	end

	def split_text(text)
		splitted = []
		first_line = true
		text.split('%%%').each do | line |
			if first_line
				line = "<strong>#{line}</strong>"
				first_line = false
			end
			splitted << "<p> #{line} </p>"
		end
		
		splitted.join('').html_safe
	end

<<<<<<< HEAD
=======
	# move to language file
	def debt_status_description(debt)
		symbol = Debts::DebtStatus.symbol(debt.debt_status_id)
		
		placement = debt.debt_placements.last
		if (placement)
			@agency = Agency.find(placement.agency_id)
		end

		case symbol
			when :draft
				"Draft (not assigned yet)"
			when :assigned
				"Assigned to #{link_to @agency.name.upcase, agency_path(@agency)}".html_safe
			when :accepted
				"Accepted by #{link_to @agency.name.upcase, agency_path(@agency)}".html_safe
			when :rejected
				"Rejected by #{link_to @agency.name.upcase, agency_path(@agency)}".html_safe
			when :inforequired
				"#{link_to @agency.name.upcase, agency_path(@agency)} requesting additional info".html_safe
			when :resolved
				"Resoved by #{link_to @agency.name.upcase, agency_path(@agency)}".html_safe
			when :closed
				"Debt is closed"
			when :deleted
				"Debt is deleted"
			else
				""
		end
	end

	def event_type_to_text(type)
		symbol = Timeline::EventType.symbol(type)
		case symbol
			when :creation
				"was created"
			when :update
				"was updated"
			when :statuschange
				"had status change"
			when :userevent
				"was commented"
			when :delete
				"was deleted"
			else
				""
		end 
	end

>>>>>>> e74b7e8... first commit to the market place app
	def debt_action(action, action_str, title=nil)
		title = action_str if !title
		code = link_to "<i></i> #{action_str}".html_safe, '#status-change', 
				:'data-toggle' => "modal", 
		        :'html-map' => "modal-title=#{title + " Debt"};modal-action=#{title.downcase}", 
		        :'value-map' => "debt_status_id=#{Debts::DebtStatus.lookup(action)}", 
		        class: "btn-icon glyphicons #{sym_status_to_glyphicon(action)} no-spinner" 

        "<li> #{code} </li>".html_safe
	end

end
