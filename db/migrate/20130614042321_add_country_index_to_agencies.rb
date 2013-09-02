class AddCountryIndexToAgencies < ActiveRecord::Migration
  def change
  	add_index :agencies, :country_id
  end
end
