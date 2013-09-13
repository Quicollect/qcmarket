require 'support/random_lookup'

FactoryGirl.define do 
	factory :debt, class: Debts::Debt do |f| 
		f.title { Faker::Lorem.sentence }
	    f.description { Faker::Lorem.paragraph }
	    f.debt_status_id { Debts::DebtStatus.lookup(:draft) }
	    f.debt_type_id { RandomLookup.rand_id(Debts::DebtType) }
	    f.charge_date { Date.today - Random.rand(365) }
	    f.debt_segment_id { RandomLookup.rand_id(Debts::DebtSegment) }
	   	f.account_id { RandomLookup.rand_id(Creditor) }
	   	f.email { Faker::Internet.email }
	    f.fax { Faker::PhoneNumber.phone_number }
	    f.phone { Faker::PhoneNumber.phone_number }
	    f.country_id { Country.lookup(:'united states') }
	    f.state_id  { State.lookup_name(Faker::AddressUS.state) }
	    f.city  { Faker::AddressUS.city }
	    f.zipcode  { Faker::AddressUS.zip_code }
	    f.amount {Money.new(100+Random.rand(1000000) )}
	end 

	factory :invalid_debt, parent: :debt do |f| 
		f.title { "" }
		f.email { "not_vaid_email@"}
	end  
end