class CreateDebtFiles < ActiveRecord::Migration
  def change
    create_table :debt_files do |t|
	  t.integer :debt_id
	  t.integer :resource_id
      t.timestamps
    end

    add_index :debt_files, :debt_id
    add_index :debt_files, :resource_id
  end
end
