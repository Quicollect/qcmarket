class AddCountryToDebts < ActiveRecord::Migration
  def change
    add_column :debts, :country_id, :integer
  end
end
