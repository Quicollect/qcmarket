require 'spec_helper'

describe "agency_reviews/index" do
  before(:each) do
    assign(:agency_reviews, [
      stub_model(AgencyReview,
        :agency => nil,
        :review_level => 1,
        :service_level => 2,
        :aggresive_level => 3,
        :speed_level => 4,
        :description => "Description"
      ),
      stub_model(AgencyReview,
        :agency => nil,
        :review_level => 1,
        :service_level => 2,
        :aggresive_level => 3,
        :speed_level => 4,
        :description => "Description"
      )
    ])
  end

  it "renders a list of agency_reviews" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
