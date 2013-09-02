require 'spec_helper'

describe "price_models/index" do
  before(:each) do
    assign(:price_models, [
      stub_model(PriceModel,
        :agency_id => 1,
        :max_age => 2,
        :min_amount => 1.5,
        :fee_precentage => 1.5
      ),
      stub_model(PriceModel,
        :agency_id => 1,
        :max_age => 2,
        :min_amount => 1.5,
        :fee_precentage => 1.5
      )
    ])
  end

  it "renders a list of price_models" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
