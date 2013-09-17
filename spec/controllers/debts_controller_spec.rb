require 'spec_helper'
require 'factories/users'
require 'support/user_login'

describe DebtsController do
	render_views
	include Devise::TestHelpers

	before(:each) do
    	@request.env["devise.mapping"] = Devise.mappings[:user]
    	sign_in UserLogin.creditor
  	end

	describe "Check #new working" do
		
		subject { get :new, format: :html }

		it "should return new debt page" do
			puts "Body: #{response.body}"
			response.should have_selector("title", text: "Quicollect | New Debt")
		end
	end
end
