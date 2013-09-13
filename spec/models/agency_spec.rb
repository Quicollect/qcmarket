require 'spec_helper'
require 'factories/agencies'

describe Agency do
  	
  	before(:each) do
		@count = Agency.all.length	
  	end

	describe "creating agency" do

  		it "should create a agency" do
  			Agency.create!(FactoryGirl.attributes_for(:agency) )
  			@count.should eq(Agency.all.length - 1)
  		end

  		it "should not create a agency" do
  			@error = nil
  			begin 
  				Agency.create!(FactoryGirl.attributes_for(:invalid_agency) )
  			rescue => e
  				@error = e 
  			end
  			@error.to_s.should eq("Validation failed: Name can't be blank")
  			@count.should eq(Agency.all.length)
  		end
  	end
end
