class RemoveAmountAndAgeFromAgencyServices < ActiveRecord::Migration
  def change
  	remove_column :agency_services, :min_amount, :float
  	remove_column :agency_services, :max_age,  :integer
  end
end
