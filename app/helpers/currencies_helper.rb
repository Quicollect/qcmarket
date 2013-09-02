module CurrenciesHelper

	def major_currencies
		Rails.application.config.currencies.select {|x,y| y[:priority] < 10 }
	end

	def other_currencies
		Rails.application.config.currencies.select {|x,y| y[:priority] >= 10 }
	end

	def all_currencies
		Rails.application.config.currencies
	end

	def currency_symbol(iso_code)
		Rails.application.config.currencies[iso_code.downcase.to_sym][:symbol]
	end
	
	def humenize_money(money)
		humanized_money_with_symbol(money)
	end
end