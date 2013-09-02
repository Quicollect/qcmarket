class Country < ActiveRecord::Base
	extend Lookup

	has_many :agencies

	def self.find_ex(id)
		id.nil? ? Country.find_by_name('Unknown') : Country.find(id)
	end
<<<<<<< HEAD

	def i18n_name
		I18n.t(self.initials.to_sym, :scope => :countries)
	end
=======
>>>>>>> e74b7e8... first commit to the market place app
end
