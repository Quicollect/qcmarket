class AddNotesToAgencies < ActiveRecord::Migration
  def change
    add_column :agencies, :notes, :string
  end
end
