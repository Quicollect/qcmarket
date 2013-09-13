class ReviewsController < ApplicationController
  
  load_and_authorize_resource :review

  before_action :load_defaults
  before_action :set_review, only: [:show, :edit, :update, :destroy]


  # GET /agency_reviews/new
  def new
    @review = @debt_placement.build_review
    @review.user_id = current_user.id
    @review.agency_id = @debt_placement.agency_id

    render :file => "reviews/_form.html.erb", layout: false
  end

  # GET /agency_reviews/1/edit
  def edit

  end

  # POST /agency_reviews
  def create
    @review = @agency.reviews.new(review_params)
    @review.user_id = current_user.id
    @review.agency_id = @debt_placement.agency_id

    #TODO: add validation that the user own the debt

    if @agency.save
      flash[:success] = 'Agency review was successfully created.'
      redirect_to agency_reviews_path(@agency)
    else
      flash[:error] = 'Failed creating agency review. If this problem persists please contact support@quicollect.com'
      redirect_to agency_path(@agency)
    end
  end

  # PATCH/PUT /agency_reviews/1
  def update
    @review.user_id = current_user.id

    if @review.update(review_params)
      flash[:success] = 'Agency review was successfully updated.'
      redirect_to [@debt, @debt_placement, @agency_review]
    else
      render action: 'edit'
    end
  end

  # DELETE /agency_reviews/1
  def destroy
    @review.destroy
    flash[:success] = 'Agency review was successfully deleted.'
    redirect_to agency_reviews_path(@agency)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @agency_review = Review.find(params[:review_id])
    end

    # Only allow a trusted parameter "white list" through.
    def review_params
      params.require(:review).permit(:debt_placement_id, :review_level, :service_level, :aggresive_level, :speed_level, :description)
    end

    def load_defaults
      @debt_placement = Debts::Placement.find(params[:id])
      @debt = Debt.find(@debt_placement.debt_id)
      @agency = Agency.find(@debt_placement.agency_id)
    end

    def agency_reviews_path(agency)
        agency_path(agency) + "#reviews"
    end
end
