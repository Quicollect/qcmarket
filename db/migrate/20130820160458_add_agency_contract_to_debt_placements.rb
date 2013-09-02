class AddAgencyContractToDebtPlacements < ActiveRecord::Migration
  def change
	add_column :debt_placements, :agency_contract_id, :integer
  	add_index :debt_placements, :agency_contract_id
  end
end
