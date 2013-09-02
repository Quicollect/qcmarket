require "spec_helper"

describe CreditorsController do
  describe "routing" do

    it "routes to #index" do
      get("/creditors").should route_to("creditors#index")
    end

    it "routes to #new" do
      get("/creditors/new").should route_to("creditors#new")
    end

    it "routes to #show" do
      get("/creditors/1").should route_to("creditors#show", :id => "1")
    end

    it "routes to #edit" do
      get("/creditors/1/edit").should route_to("creditors#edit", :id => "1")
    end

    it "routes to #create" do
      post("/creditors").should route_to("creditors#create")
    end

    it "routes to #update" do
      put("/creditors/1").should route_to("creditors#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/creditors/1").should route_to("creditors#destroy", :id => "1")
    end

  end
end
