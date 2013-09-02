require "spec_helper"

describe AgencyReviewsController do
  describe "routing" do

    it "routes to #index" do
      get("/agency_reviews").should route_to("agency_reviews#index")
    end

    it "routes to #new" do
      get("/agency_reviews/new").should route_to("agency_reviews#new")
    end

    it "routes to #show" do
      get("/agency_reviews/1").should route_to("agency_reviews#show", :id => "1")
    end

    it "routes to #edit" do
      get("/agency_reviews/1/edit").should route_to("agency_reviews#edit", :id => "1")
    end

    it "routes to #create" do
      post("/agency_reviews").should route_to("agency_reviews#create")
    end

    it "routes to #update" do
      put("/agency_reviews/1").should route_to("agency_reviews#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/agency_reviews/1").should route_to("agency_reviews#destroy", :id => "1")
    end

  end
end
