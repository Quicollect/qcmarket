require 'spec_helper'

describe "creditors/edit" do
  before(:each) do
    @creditor = assign(:creditor, stub_model(Creditor))
  end

  it "renders the edit creditor form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", creditor_path(@creditor), "post" do
    end
  end
end
