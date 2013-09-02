class AddPriceModelsDebtTypes < ActiveRecord::Migration
	def change
		create_table :price_models_debt_types, :id => false do |t|
		  	t.references :price_model, :null => false
		  	t.references :debt_type, :null => false
		end

		add_index :price_models_debt_types, 
					[:price_model_id, :debt_type_id],
						unique: true,
							name: "price_models_debt_types_index"

		add_index :price_models_debt_types, :debt_type_id
	end
end
