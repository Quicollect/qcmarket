
FactoryGirl.define do 
	factory :user do |f| 
		f.name { "#{Faker::Name.first_name} #{Faker::Name.last_name}" }
		f.email { Faker::Internet.email }
		f.password { "12345678" }
		f.password_confirmation { "12345678" }
	end 

	factory :invalid_user, parent: :user do |f| 
		f.email { "" }
	end

	factory :fixed_user, parent: :user do |f| 
		f.email { "oded.cohen972@gmail.com" }
	end 
end