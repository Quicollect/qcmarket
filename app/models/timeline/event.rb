module Timeline
	class Event < ActiveRecord::Base
		self.inheritance_column = 'entity_type'

		#belongs_to :account
		#belongs_to :user
		#belongs_to :event_type, class_name: "Timeline::EventType"
		#belongs_to :entity_type, class_name: "Timeline::EntityType"

		has_many :event_files, class_name: "Timeline::EventFile"
		has_many :resources, through: :event_files
		accepts_nested_attributes_for :event_files, :allow_destroy => true
	end
end