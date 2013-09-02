class ChangeEntityTypeColumnEvents < ActiveRecord::Migration
  def change
  	remove_column :events, :entity_type
  	add_column :events, :entity_type, :string

	Timeline::Event.all.each do | e |
		e.entity_type = "Timeline::DebtEvent"
		e.save
	end
  end
end
