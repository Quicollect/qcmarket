class SwitchAgenciesCountryToId < ActiveRecord::Migration
  def change
  	
	# add the id column
  	add_column :agencies, :country_id, :integer

	# now delete the string column
  	remove_column :agencies, :country, :string
  end
end
