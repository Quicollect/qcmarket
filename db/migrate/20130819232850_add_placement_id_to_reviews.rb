class AddPlacementIdToReviews < ActiveRecord::Migration
  def change
    add_column :reviews, :debt_placement_id, :integer
    add_index :reviews, :debt_placement_id

    remove_index :reviews, :agency_id
    add_index :reviews, [:agency_id, :debt_placement_id], unique: true
  end
end
