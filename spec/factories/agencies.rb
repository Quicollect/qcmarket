
FactoryGirl.define do 
	factory :agency do |f| 
		f.name { Faker::Company.name }
		f.accountable_type { "Agency"}
	    f.website { Faker::Internet.domain_name }
	    f.notes { Faker::Lorem.paragraph }
	    f.enabled { true } 
	    #f.logo_resource_id
	   	f.email { Faker::Internet.email }
	    f.fax { Faker::PhoneNumber.phone_number }
	    f.phone { Faker::PhoneNumber.phone_number }
	    f.country_id { Country.lookup(:'united states') }
	    f.state_id  { State.lookup_name(Faker::AddressUS.state) }
	    # f.address  { Faker::Address }
	    f.city  { Faker::AddressUS.city }
	    f.zipcode  { Faker::AddressUS.zip_code }
	    
	end 

	factory :invalid_agency, parent: :agency do |f| 
		f.name { "" }
	end  
end