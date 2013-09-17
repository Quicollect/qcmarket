class AddContactNameToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :contact_name, :string
  end
end
