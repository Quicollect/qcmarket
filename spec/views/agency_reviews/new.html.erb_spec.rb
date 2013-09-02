require 'spec_helper'

describe "agency_reviews/new" do
  before(:each) do
    assign(:agency_review, stub_model(AgencyReview,
      :agency => nil,
      :review_level => 1,
      :service_level => 1,
      :aggresive_level => 1,
      :speed_level => 1,
      :description => "MyString"
    ).as_new_record)
  end

  it "renders new agency_review form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", agency_reviews_path, "post" do
      assert_select "input#agency_review_agency[name=?]", "agency_review[agency]"
      assert_select "input#agency_review_review_level[name=?]", "agency_review[review_level]"
      assert_select "input#agency_review_service_level[name=?]", "agency_review[service_level]"
      assert_select "input#agency_review_aggresive_level[name=?]", "agency_review[aggresive_level]"
      assert_select "input#agency_review_speed_level[name=?]", "agency_review[speed_level]"
      assert_select "input#agency_review_description[name=?]", "agency_review[description]"
    end
  end
end
