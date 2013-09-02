class CreateDebts < ActiveRecord::Migration
  def change
    create_table :debts do |t|
      t.string :title
      t.string :address
      t.integer :debt_type_id
      t.date :charge_date
      t.float :amount
      t.string :description
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
