class AddIndexesToAgenciesAndAccounts < ActiveRecord::Migration
  def change
  	add_index :accounts, :country_id
  	add_index :accounts, :accountable_id
  end
end
