require 'spec_helper'

describe "agency_reviews/show" do
  before(:each) do
    @agency_review = assign(:agency_review, stub_model(AgencyReview,
      :agency => nil,
      :review_level => 1,
      :service_level => 2,
      :aggresive_level => 3,
      :speed_level => 4,
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/3/)
    rendered.should match(/4/)
    rendered.should match(/Description/)
  end
end
