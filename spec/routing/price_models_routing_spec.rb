require "spec_helper"

describe PriceModelsController do
  describe "routing" do

    it "routes to #index" do
      get("/price_models").should route_to("price_models#index")
    end

    it "routes to #new" do
      get("/price_models/new").should route_to("price_models#new")
    end

    it "routes to #show" do
      get("/price_models/1").should route_to("price_models#show", :id => "1")
    end

    it "routes to #edit" do
      get("/price_models/1/edit").should route_to("price_models#edit", :id => "1")
    end

    it "routes to #create" do
      post("/price_models").should route_to("price_models#create")
    end

    it "routes to #update" do
      put("/price_models/1").should route_to("price_models#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/price_models/1").should route_to("price_models#destroy", :id => "1")
    end

  end
end
