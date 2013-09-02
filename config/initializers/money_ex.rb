class Money
	def to_s_with_currency
		to_s + " (#{currency.iso_code})"
	end
end