class AddDatesToDebtPlacements < ActiveRecord::Migration
  def change
    add_column :debt_placements, :accepted_at, :datetime
    add_column :debt_placements, :resolved_at, :datetime
  end
end
