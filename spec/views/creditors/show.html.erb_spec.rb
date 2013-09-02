require 'spec_helper'

describe "creditors/show" do
  before(:each) do
    @creditor = assign(:creditor, stub_model(Creditor))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
