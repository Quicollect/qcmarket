class State < ActiveRecord::Base
	extend Lookup
	
	belongs_to :country
end
