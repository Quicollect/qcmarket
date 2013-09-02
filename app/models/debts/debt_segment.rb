module Debts
	class DebtSegment < ActiveRecord::Base
		extend Lookup
		
		has_many :debts
		has_many :agency_services

		# TODO: move to DB
		def thumbnail
			case id
				when 1
				  'icon-money'
				when 2
				  'icon-ambulance'
				when 3
				  'icon-lightbulb'
				when 4
				  'icon-phone'
				when 5
				  'icon-tint'
				when 6
				  'icon-legal'
				when 7
				  'icon-shoping-cart'
				else
				  ''
			end
		end
	end
end