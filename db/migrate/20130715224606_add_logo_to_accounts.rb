class AddLogoToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :logo_resource_id, :integer
  end
end
