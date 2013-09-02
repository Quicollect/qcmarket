# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# create the system account
puts 'checking default accounts'
account = Account.find_by_name("System")
if (account.nil?) 
	account = Account.new(name: "System", accountable_type: "Account", website: "www.quicollect.com", email: "system@quicollect.com", country_id: Country.find_by_name("United States").id)
	account.save
end

# create the admin user
puts 'checking default users'
if (!User.find_by_email("system@quicollect.com"))
	user = User.new(name: "System", account_id: account.id, email: "system@quicollect.com", password: "system.admin972", password_confirmation: "system.admin972")
	user.roles = User.valid_roles
	user.save
end

puts 'checking event types'
if (Timeline::EventType.all.length == 0)
	Timeline::EventType.create(name: 'Creation')
	Timeline::EventType.create(name: 'StatusChange')
	Timeline::EventType.create(name: 'Update')
	Timeline::EventType.create(name: 'UserEvent')
	Timeline::EventType.create(name: 'Delete')
end

puts 'checking us states'
if (State.all.length == 0)
	require 'csv'
    i = 0
    cid = Country.lookup(:'united states')
    CSV.foreach(Rails.root.join('db/data/us-states.csv'), :headers => false, :col_sep => "\t") do |row|
      i += 1
      s = State.create!(name: row[0],initials: row[3], country_id: cid)      
      
      puts "#{i}. #{s.name} (#{s.initials}) [#{s.id}]"
    end
end



puts 'checking debt statuses'
if (Debts::DebtStatus.all.length == 0)
	Debts::DebtStatus.create(name: 'Draft') 		# notes_2
	Debts::DebtStatus.create(name: 'Assigned')		# message_flag
	Debts::DebtStatus.create(name: 'Accepted')		# check
	Debts::DebtStatus.create(name: 'Rejected')		# ban
	Debts::DebtStatus.create(name: 'Resolved')			# coins
	Debts::DebtStatus.create(name: 'Closed')		# remove2
	Debts::DebtStatus.create(name: 'InfoRequired')	# warning_sign
	Debts::DebtStatus.create(name: 'Deleted')

	# now initialize all existing debts
	Debts::Debt.all.each do | debt |
		debt.debt_status_id = Debts::DebtStatus.all.first.id
		debt.save
	end
end


puts 'clearing cache'
Rails.cache.clear

puts 'done!'





