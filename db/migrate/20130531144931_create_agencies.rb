class CreateAgencies < ActiveRecord::Migration
  def change
    create_table :agencies do |t|
      t.string :name
      t.string :website
      t.string :phone
      t.string :email
      t.string :address
      t.string :country
      t.float :latitude
      t.float :longitude
      t.boolean :gmaps, :default => true
      t.timestamps
    end
  end
end
