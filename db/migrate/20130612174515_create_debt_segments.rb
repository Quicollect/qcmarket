class CreateDebtSegments < ActiveRecord::Migration
  def change
    create_table :debt_segments do |t|
	  t.string :name
	  t.string :description
      t.timestamps
    end

    # add id column to debt & agency services
  	add_column :debts, :debt_segment_id, :integer
  	add_column :agency_services, :debt_segment_id, :integer

	  # update relevant index
  	remove_index :agency_services, [:agency_id, :debt_type_id]
  	add_index :agency_services, [:agency_id, :debt_type_id, :debt_segment_id], 
  			unique: true, name: "agency_debt_type_debt_segment"
  end
end
