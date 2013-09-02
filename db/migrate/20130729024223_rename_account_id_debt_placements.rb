class RenameAccountIdDebtPlacements < ActiveRecord::Migration
  def change
  	rename_column :debt_placements, :account_id, :agency_id
  end
end
