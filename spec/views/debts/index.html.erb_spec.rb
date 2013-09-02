require 'spec_helper'

describe "debts/index" do
  before(:each) do
    assign(:debts, [
      stub_model(Debt,
        :title => "Title",
        :address => "Address",
        :type => 1,
        :amount => 1.5,
        :description => "Description"
      ),
      stub_model(Debt,
        :title => "Title",
        :address => "Address",
        :type => 1,
        :amount => 1.5,
        :description => "Description"
      )
    ])
  end

  it "renders a list of debts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
  end
end
