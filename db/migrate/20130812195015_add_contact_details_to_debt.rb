class AddContactDetailsToDebt < ActiveRecord::Migration
  def change
  	add_column :debts, :city, :string, default: '' 
  	add_column :debts, :zipcode, :string, default: ''
  	add_column :debts, :state_id, :integer
  	add_column :debts, :phone, :string
  	add_column :debts, :fax, :string
  	add_column :debts, :email, :string
  end
end
