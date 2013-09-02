require 'spec_helper'

describe "debts/show" do
  before(:each) do
    @debt = assign(:debt, stub_model(Debt,
      :title => "Title",
      :address => "Address",
      :type => 1,
      :amount => 1.5,
      :description => "Description"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
    rendered.should match(/Address/)
    rendered.should match(/1/)
    rendered.should match(/1.5/)
    rendered.should match(/Description/)
  end
end
