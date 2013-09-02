require 'spec_helper'

describe "price_models/edit" do
  before(:each) do
    @price_model = assign(:price_model, stub_model(PriceModel,
      :agency_id => 1,
      :max_age => 1,
      :min_amount => 1.5,
      :fee_precentage => 1.5
    ))
  end

  it "renders the edit price_model form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", price_model_path(@price_model), "post" do
      assert_select "input#price_model_agency_id[name=?]", "price_model[agency_id]"
      assert_select "input#price_model_max_age[name=?]", "price_model[max_age]"
      assert_select "input#price_model_min_amount[name=?]", "price_model[min_amount]"
      assert_select "input#price_model_fee_precentage[name=?]", "price_model[fee_precentage]"
    end
  end
end
