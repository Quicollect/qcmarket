class AddFlagsToAgencies < ActiveRecord::Migration
  def change
    add_column :agencies, :verified, :boolean, default: false
    add_column :agencies, :enabled, :boolean, default: true
  end
end
