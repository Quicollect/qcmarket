require 'spec_helper'

describe "creditors/index" do
  before(:each) do
    assign(:creditors, [
      stub_model(Creditor),
      stub_model(Creditor)
    ])
  end

  it "renders a list of creditors" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
