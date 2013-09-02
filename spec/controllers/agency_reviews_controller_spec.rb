require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe AgencyReviewsController do

  # This should return the minimal set of attributes required to create a valid
  # AgencyReview. As you add validations to AgencyReview, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { "agency" => "" }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AgencyReviewsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all agency_reviews as @agency_reviews" do
      agency_review = AgencyReview.create! valid_attributes
      get :index, {}, valid_session
      assigns(:agency_reviews).should eq([agency_review])
    end
  end

  describe "GET show" do
    it "assigns the requested agency_review as @agency_review" do
      agency_review = AgencyReview.create! valid_attributes
      get :show, {:id => agency_review.to_param}, valid_session
      assigns(:agency_review).should eq(agency_review)
    end
  end

  describe "GET new" do
    it "assigns a new agency_review as @agency_review" do
      get :new, {}, valid_session
      assigns(:agency_review).should be_a_new(AgencyReview)
    end
  end

  describe "GET edit" do
    it "assigns the requested agency_review as @agency_review" do
      agency_review = AgencyReview.create! valid_attributes
      get :edit, {:id => agency_review.to_param}, valid_session
      assigns(:agency_review).should eq(agency_review)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new AgencyReview" do
        expect {
          post :create, {:agency_review => valid_attributes}, valid_session
        }.to change(AgencyReview, :count).by(1)
      end

      it "assigns a newly created agency_review as @agency_review" do
        post :create, {:agency_review => valid_attributes}, valid_session
        assigns(:agency_review).should be_a(AgencyReview)
        assigns(:agency_review).should be_persisted
      end

      it "redirects to the created agency_review" do
        post :create, {:agency_review => valid_attributes}, valid_session
        response.should redirect_to(AgencyReview.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved agency_review as @agency_review" do
        # Trigger the behavior that occurs when invalid params are submitted
        AgencyReview.any_instance.stub(:save).and_return(false)
        post :create, {:agency_review => { "agency" => "invalid value" }}, valid_session
        assigns(:agency_review).should be_a_new(AgencyReview)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        AgencyReview.any_instance.stub(:save).and_return(false)
        post :create, {:agency_review => { "agency" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested agency_review" do
        agency_review = AgencyReview.create! valid_attributes
        # Assuming there are no other agency_reviews in the database, this
        # specifies that the AgencyReview created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        AgencyReview.any_instance.should_receive(:update).with({ "agency" => "" })
        put :update, {:id => agency_review.to_param, :agency_review => { "agency" => "" }}, valid_session
      end

      it "assigns the requested agency_review as @agency_review" do
        agency_review = AgencyReview.create! valid_attributes
        put :update, {:id => agency_review.to_param, :agency_review => valid_attributes}, valid_session
        assigns(:agency_review).should eq(agency_review)
      end

      it "redirects to the agency_review" do
        agency_review = AgencyReview.create! valid_attributes
        put :update, {:id => agency_review.to_param, :agency_review => valid_attributes}, valid_session
        response.should redirect_to(agency_review)
      end
    end

    describe "with invalid params" do
      it "assigns the agency_review as @agency_review" do
        agency_review = AgencyReview.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        AgencyReview.any_instance.stub(:save).and_return(false)
        put :update, {:id => agency_review.to_param, :agency_review => { "agency" => "invalid value" }}, valid_session
        assigns(:agency_review).should eq(agency_review)
      end

      it "re-renders the 'edit' template" do
        agency_review = AgencyReview.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        AgencyReview.any_instance.stub(:save).and_return(false)
        put :update, {:id => agency_review.to_param, :agency_review => { "agency" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested agency_review" do
      agency_review = AgencyReview.create! valid_attributes
      expect {
        delete :destroy, {:id => agency_review.to_param}, valid_session
      }.to change(AgencyReview, :count).by(-1)
    end

    it "redirects to the agency_reviews list" do
      agency_review = AgencyReview.create! valid_attributes
      delete :destroy, {:id => agency_review.to_param}, valid_session
      response.should redirect_to(agency_reviews_url)
    end
  end

end
