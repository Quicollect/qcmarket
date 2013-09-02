class CreateDebtStatuses < ActiveRecord::Migration
  def change
    create_table :debt_statuses do |t|
		t.string :name
      t.timestamps
    end

    add_column :debts, :debt_status_id, :integer
  end
end
