class CreateDebtTypes < ActiveRecord::Migration
  def change
    create_table :debt_types do |t|
	  t.string :name
      t.timestamps
    end
  end
end
