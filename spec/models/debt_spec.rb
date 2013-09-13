require 'spec_helper'
require 'factories/debts'

describe Debts::Debt do
  	
  	before(:each) do
		  @count = Debts::Debt.all.length	
  	end

	describe "creating debts" do

  		it "should create a debt" do
  			Debts::Debt.create!(FactoryGirl.attributes_for(:debt) )
  			@count.should eq(Debts::Debt.all.length - 1)
  		end

  		it "should not create a debt" do
  			@error = nil
  			begin 
  				Debts::Debt.create!(FactoryGirl.attributes_for(:invalid_debt) )
  			rescue => e
  				@error = e 
  			end
  			@error.to_s.should eq("Validation failed: Title can't be blank, Email is invalid")
  			@count.should eq(Debts::Debt.all.length)
  		end
  	end
end
