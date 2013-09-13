module Timeline
	class Event < ActiveRecord::Base
		self.inheritance_column = 'entity_type'

		has_many :event_files, class_name: "Timeline::EventFile"
		has_many :resources, through: :event_files
		accepts_nested_attributes_for :event_files, :allow_destroy => true
	end
end