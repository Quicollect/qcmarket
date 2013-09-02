class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :agency, index: true, :null => false
      t.integer :review_level
      t.integer :service_level
      t.integer :aggresive_level
      t.integer :speed_level
      t.string :description

      t.timestamps
    end
  end
end
