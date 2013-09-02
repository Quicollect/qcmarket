class ChangeMoneyToInteger < ActiveRecord::Migration
  def change
	add_money :debts, :amount
	add_money :debts, :amount_paid
	add_money :debt_payments, :amount
	add_money :price_models, :min_amount
	add_money :price_models, :max_amount
	
	# move data to the new field
	arr = [	{cls: Debts::Debt, members: [:amount, :amount_paid]},
			{cls: Debts::DebtPayment, members: [:amount]},
			{cls: PriceModel, members: [:min_amount, :max_amount]} ]

	
	arr.each do | migration |
		puts "migrating #{migration[:cls].to_s}"
		migration[:cls].all.each do | obj |
			migration[:members].each do | member |
				if (obj[member] > 10000000)
					val = 100*10000000
				else
					val = 100*obj[member];
				end
				obj[member.to_s + '_cents'] = val
			end

			obj.save
		end
	end

	# now remove old fields
	remove_column :debts, :amount
	remove_column :debts, :amount_paid
	remove_column :debt_payments, :amount
	remove_column :price_models, :min_amount
	remove_column :price_models, :max_amount

  end 	
end
