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
