require 'spec_helper'
require 'factories/users'

describe RegistrationsController do
	
	before(:each) do
    	@request.env["devise.mapping"] = Devise.mappings[:user]
    	@users_count = User.all.length
		@account_count = Account.all.length	
  	end

	describe "POST #create" do

		it "should not create a user or account" do	
		    post :create, user: FactoryGirl.attributes_for(:invalid_user) 
		    
		    @users_count.should eq(User.all.length)
		    @account_count.should eq(Account.all.length)
		    expect(response.status).to eq(200)
		end

	    it "should create a user and account" do
			post :create, user: FactoryGirl.attributes_for(:user) 
		    
		    @users_count.should eq(User.all.length - 1)
		    @account_count.should eq(Account.all.length - 1)
		    response.should redirect_to(sign_in_path)
	    end
	end
end
