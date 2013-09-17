require 'factories/users'

class UserLogin
	def self.creditor
		user_attr = FactoryGirl.attributes_for(:fixed_user) 
		user = User.all.find_by_email(user_attr[:email])
		if !user
			user = User.new(user_attr)
			user.account_id = Creditor.all.first.id
			user.roles << [:creditor, :user, :account_admin]
			user.save
			user.confirm!
		end
		user
	end

end
