class CreateAgencyServices < ActiveRecord::Migration
  def change
    create_table :agency_services do |t|
	  t.integer :agency_id
	  t.integer :debt_type_id
	  
	  t.integer :max_age
	  t.float :min_amount
      t.timestamps
    end

    add_index :agency_services, [:agency_id, :debt_type_id], unique: true
  end
end
