require 'spec_helper'

describe "debts/edit" do
  before(:each) do
    @debt = assign(:debt, stub_model(Debt,
      :title => "MyString",
      :address => "MyString",
      :type => 1,
      :amount => 1.5,
      :description => "MyString"
    ))
  end

  it "renders the edit debt form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", debt_path(@debt), "post" do
      assert_select "input#debt_title[name=?]", "debt[title]"
      assert_select "input#debt_address[name=?]", "debt[address]"
      assert_select "input#debt_type[name=?]", "debt[type]"
      assert_select "input#debt_amount[name=?]", "debt[amount]"
      assert_select "input#debt_description[name=?]", "debt[description]"
    end
  end
end
