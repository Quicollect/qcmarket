class AddAdditionalAddressMembers < ActiveRecord::Migration
  def change
  	add_column :accounts, :city, :string, default: '' 
  	add_column :accounts, :zipcode, :string, default: ''
  	add_column :accounts, :state_id, :integer
  end
end
