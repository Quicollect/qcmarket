class AddFaxToAgencies < ActiveRecord::Migration
  def change
    add_column :agencies, :fax, :string
  end
end
