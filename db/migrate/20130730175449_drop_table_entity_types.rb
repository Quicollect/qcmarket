class DropTableEntityTypes < ActiveRecord::Migration
  def change
  	drop_table :entity_types 
  end
end
