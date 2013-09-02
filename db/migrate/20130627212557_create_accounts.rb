class CreateAccounts < ActiveRecord::Migration
  def change
	# we create the accounts table as a parent table
    create_table :accounts do |t|
      t.integer :accountable_id
      t.string :accountable_type, null: false # inheritence usage
      t.string :name
      t.string :website
      t.string :phone
      t.string :fax
      t.string :email
      t.string :address
      t.string :notes
      t.integer :country_id
      t.float :latitude
      t.float :longitude
      t.boolean :gmaps, default: true
      t.boolean :enabled, default: true
      t.timestamps
    end
  end
end
