module Timeline
	class EventType < ActiveRecord::Base
		extend Lookup
		
		has_many :events, class_name: "Timeline::Event"
	end
end