module Timeline
	class EventFile < ActiveRecord::Base
		belongs_to :event, class_name: "Timeline::Event"
		belongs_to :resource
	end
end