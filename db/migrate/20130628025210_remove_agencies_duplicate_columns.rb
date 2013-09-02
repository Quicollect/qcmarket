class RemoveAgenciesDuplicateColumns < ActiveRecord::Migration
  def self.up
  	remove_column :agencies, :name, :string
  	remove_column :agencies, :website,  :string
  	remove_column :agencies, :phone, :string
  	remove_column :agencies, :fax, :string
  	remove_column :agencies, :email,  :string
  	remove_column :agencies, :address, :string
  	remove_column :agencies, :notes, :string
  	remove_column :agencies, :country_id,  :integer
  	remove_column :agencies, :latitude, :float
  	remove_column :agencies, :longitude,  :float
  	remove_column :agencies, :gmaps, :boolean, default: true
  	remove_column :agencies, :enabled, :boolean, default: true
  end

  def self.down
    add_column :agencies, :name, :string
    add_column :agencies, :website,  :string
    add_column :agencies, :phone, :string
    add_column :agencies, :fax, :string
    add_column :agencies, :email,  :string
    add_column :agencies, :address, :string
    add_column :agencies, :notes, :string
    add_column :agencies, :country_id,  :integer
    add_column :agencies, :latitude, :float
    add_column :agencies, :longitude,  :float
    add_column :agencies, :gmaps, :boolean, default: true
    add_column :agencies, :enabled, :boolean, default: true

    add_index :agencies, :country_id
  end

end
