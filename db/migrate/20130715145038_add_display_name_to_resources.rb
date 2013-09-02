class AddDisplayNameToResources < ActiveRecord::Migration
  def change
    add_column :resources, :display_name, :string
  end
end
