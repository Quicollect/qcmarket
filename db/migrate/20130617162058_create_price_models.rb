class CreatePriceModels < ActiveRecord::Migration
  def change
    create_table :price_models do |t|
      t.string :name
      t.integer :agency_id
      t.integer :min_age
      t.integer :max_age
      t.integer :min_amount
      t.integer :max_amount
      t.float :fee_precentage
      t.string :description
      t.boolean :enabled
      t.boolean :system, default: false

      t.timestamps
    end

      add_index :price_models, :agency_id
  end
end
