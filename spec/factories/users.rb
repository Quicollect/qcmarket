
FactoryGirl.define do 
	factory :user do |f| 
		f.name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
		f.email { "oded.cohen972@gmail.com" }
		f.password { "12345678" }
		f.password_confirmation { "12345678" }
	end 

	factory :invalid_user, parent: :user do |f| 
		f.email { "" }
	end 
end