class PriceModelsController < ApplicationController

  load_and_authorize_resource :price_model
  before_action :set_agency
  before_action :set_price_model, only: [:show, :edit, :update, :destroy]

  helper_method :sort_column, :sort_direction

  def index
    authorize! :index, PriceModel.new

    @price_models = @agency.price_models.order(sort_column + " " + sort_direction).paginate(per_page: 10, page: params[:page])

    render partial: 'shared/price_models'
  end

  def show
    add_breadcrumb @price_model.name
  end

  def new
    @price_model = @agency.price_models.build

    add_breadcrumb "New"
  end

  def edit
    add_breadcrumb @price_model.name, agency_price_model_path(@agency, @price_model)
    add_breadcrumb 'Edit'
  end

  def create
    @price_model = @agency.price_models.new(price_model_params)

    if @price_model.save
      flash[:success] = 'Price model was successfully created.'
      redirect_to agency_price_models_path(@agency)
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /price_models/1
  def update
    if @price_model.update(price_model_params)
      flash[:success] = 'Price model was successfully updated.'
      redirect_to [@agency, @price_model]
    else
      render action: 'edit'
    end
  end

  # DELETE /price_models/1
  def destroy
    @price_model.destroy
    flash[:success] = 'Price model was successfully deleted.'
    redirect_to agency_price_models_path(@agency)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_price_model
      @price_model = PriceModel.find(params[:id])
    end

    def set_agency
      @agency = Agency.find(params[:agency_id])

      # add_breadcrumb "Agencies", :agencies_path
      # add_breadcrumb @agency.name, agency_path(@agency)
      # add_breadcrumb 'Price Models', agency_price_models_path(@agency)
    end

    # Only allow a trusted parameter "white list" through.
    def price_model_params
      params.require(:price_model).permit(
                      :name, :min_age, :max_age, 
                      :min_amount, :max_amount, 
                      :enabled, :fee_precentage, {:debt_type_ids => []}, :description)
    end

end
