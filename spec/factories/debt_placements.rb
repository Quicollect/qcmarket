
FactoryGirl.define do 
	factory :debt_placement, class: Debts::DebtPlacement do |f| 
		f.name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
		f.email { Faker::Internet.email }
		f.password { "12345678" }
		f.password_confirmation { "12345678" }
	end 

	factory :invalid_debt_placement, parent: :debt_placement do |f| 
		f.email { "" }
	end
end