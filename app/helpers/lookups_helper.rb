module LookupsHelper
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
		sym_status_to_glyphicon(Debts::Status.symbol(status))
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
			when :notification
				"envelope"
			else
				""
		end 
	end

	def item_to_fontawesome(shoppinglist_item)
		symbol = Debts::ShoppinglistItemStatus.symbol(shoppinglist_item.shoppinglist_item_status_id)
		case symbol
			when :listed
				"icon-list"
			when :contacted
				"icon-envelope"
			when :accepted
				"icon-ok"
			when :placed
				"icon-pushpin"
			else
				""
		end 
	end
end