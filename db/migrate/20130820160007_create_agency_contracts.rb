class CreateAgencyContracts < ActiveRecord::Migration
  def change
    create_table :agency_contracts do |t|
	  t.integer :agency_id
	  t.text :content
	  t.boolean :active
      t.timestamps
    end

    add_index :agency_contracts, :agency_id
  end
end
