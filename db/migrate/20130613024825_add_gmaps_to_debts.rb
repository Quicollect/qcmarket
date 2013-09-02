class AddGmapsToDebts < ActiveRecord::Migration
  def change
    add_column :debts, :gmaps, :boolean, default: true
  end
end
