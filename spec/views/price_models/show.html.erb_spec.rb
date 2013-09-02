require 'spec_helper'

describe "price_models/show" do
  before(:each) do
    @price_model = assign(:price_model, stub_model(PriceModel,
      :agency_id => 1,
      :max_age => 2,
      :min_amount => 1.5,
      :fee_precentage => 1.5
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
  end
end
