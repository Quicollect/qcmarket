# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

#
# creating all lookups
#

puts 'checking debt types'
if Debts::Type.all.length == 0
    Debts::Type.create!(name: 'Commercial')
    Debts::Type.create!(name: 'Consumer')
end

puts 'checking debt segments'
if Debts::Segment.all.length == 0 
    Debts::Segment.create(name: 'Financial', description: "Loans, Credit debts, Morgages etc.")
    Debts::Segment.create(name: 'Medical', description: "Medical/Healthcare bills")
    Debts::Segment.create(name: 'Energy', description: "Gas & Electricity bills")
    Debts::Segment.create(name: 'Telco', description: "Phone, Internet, TV/cable etc. bills")
    Debts::Segment.create(name: 'Water', description: "Water bills")
    Debts::Segment.create(name: 'Public', description: "Goverment organizations / Public sector charges")
    Debts::Segment.create(name: 'Commerce', description: "Wholesale / Retail debts")
	  Debts::Segment.create(name: 'Education', description: "")
    Debts::Segment.create(name: 'Other', description: "")
end

puts 'checking event types'
if (Timeline::EventType.all.length == 0)
	Timeline::EventType.create(name: 'Creation')
	Timeline::EventType.create(name: 'StatusChange')
	Timeline::EventType.create(name: 'Update')
	Timeline::EventType.create(name: 'UserEvent')
	Timeline::EventType.create(name: 'Delete')
  Timeline::EventType.create(name: 'Notification')
end


puts 'checking countries'
if (Country.all.length == 0)
    i = 0
    CSV.foreach(Rails.root.join('db/data/countries.csv'), :headers => true, :col_sep => "\t") do |row|
      i += 1
      c = Country.create!(name: row[4],initials: row[0])      
      
      puts "#{i}. #{c.name} (#{c.initials}) [#{c.id}]"
    end
end

puts 'checking us states'
if (State.all.length == 0)
    i = 0
    cid = Country.lookup(:'united states')
    CSV.foreach(Rails.root.join('db/data/us-states.csv'), :headers => false, :col_sep => "\t") do |row|
      i += 1
      s = State.create!(name: row[0],initials: row[3], country_id: cid)      
      
      puts "#{i}. #{s.name} (#{s.initials}) [#{s.id}]"
    end
end

puts 'checking debt statuses'
if Debts::Status.all.length == 0
	Debts::Status.create(name: 'Draft')
	Debts::Status.create(name: 'Assigned')
	Debts::Status.create(name: 'Accepted')
	Debts::Status.create(name: 'Rejected')
	Debts::Status.create(name: 'Resolved')
	Debts::Status.create(name: 'Closed')
	Debts::Status.create(name: 'InfoRequired')
	Debts::Status.create(name: 'Deleted')

	# now initialize all existing debts
	Debt.all.each do | debt |
		debt.update(debt_status_id: Debts::Status.all.first.id)
	end
end

puts 'checking shoppinglist items statuses'
if Debts::ShoppinglistItemStatus.all.length == 0
  names = ['Listed', 'Contacted', 'Accepted', 'Placed']
  
  names.each do |name|
    Debts::ShoppinglistItemStatus.create(name: name)
  end


  Debts::ShoppinglistItem.all.each do |item|
    item.update(shoppinglist_item_status_id: Debts::ShoppinglistItemStatus.all.first.id)
  end
end



#
# initializing base entities
#

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


puts "Creating base price models"
if (PriceModel.all.length == 0)
  PriceModel.create!(name: 'Class 3 (a)', agency_id: nil, enabled:true, system:true,
                      description: 'low ranking debt due to small amount',
                      min_age: 0, max_age: 3650,
                      min_amount: Money.new(0), max_amount: Money.new(1000*100),
                      fee_precentage: 45,
                      debt_type: Debts::Type.all)

  PriceModel.create!(name: 'Class 3 (b)', agency_id: nil, enabled:true, system:true,
                      description: 'low ranking debt due to medium amount and high age',
                      min_age: 365, max_age: 3650,
                      min_amount: Money.new(1001*100), max_amount: Money.new(10000*100),
                      fee_precentage: 45,
                      debt_type: Debts::Type.all)

  PriceModel.create!(name: 'Class 2 (a)', agency_id: nil, enabled:true, system:true,
                      description: 'medium ranking debt due to medium amount',
                      min_age: 80, max_age: 365,
                      min_amount: Money.new(1001*100), max_amount: Money.new(10000*100),
                      fee_precentage: 35,
                      debt_type: Debts::Type.all)

  PriceModel.create!(name: 'Class 2 (b)', agency_id: nil, enabled:true, system:true,
                      description: 'medium ranking debt due to high amount but high age',
                      min_age: 366, max_age: 3650,
                      min_amount: Money.new(10001*100), max_amount: Money.new(10000000*100),
                      fee_precentage: 35,
                      debt_type: Debts::Type.all)    

  PriceModel.create!(name: 'Class 1 (a)', agency_id: nil, enabled:true, system:true,
                      description: 'high ranking debt due to high amount',
                      min_age: 0, max_age: 365,
                      min_amount: Money.new(10001*100), max_amount: Money.new(10000000*100),
                      fee_precentage: 25,
                      debt_type: Debts::Type.all)

  PriceModel.create!(name: 'Class 1 (b)', agency_id: nil, enabled:true, system:true,
                      description: 'high ranking debt due to medium amount but low age',
                      min_age: 0, max_age: 79,
                      min_amount: Money.new(1001*100), max_amount: Money.new(10000*100),
                      fee_precentage: 25,
                      debt_type: Debts::Type.all) 
end


puts 'clearing cache'
Rails.cache.clear

puts 'done!'





