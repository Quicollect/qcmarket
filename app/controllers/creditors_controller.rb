class CreditorsController < AccountsController
  load_and_authorize_resource :creditor  

  add_breadcrumb "Creditors", :creditors_path


  def show
    add_breadcrumb @creditor.name
    render 'edit'
  end

   # GET /creditors/new
  def new
    @creditor = Creditor.new
    add_breadcrumb "New"
    render 'edit'
  end

  # PATCH/PUT /creditor/1
  def update
    # first we update without saving
    @creditor.attributes = creditor_params

    # now if something changed in the address we resolve it again
    @creditor.resolve_address if (@creditor.full_address_changed? || !@creditor.geocoded?)

    if @creditor.save
      flash[:success] = 'Creditor was successfully updated.'
      flash[:warning] = 'Address failed to be resolved. Creditor geo assignment will not be possible as a result.' if !@creditor.geocoded?
      redirect_to @creditor
    else
      render action: 'edit'
    end
  end

    # POST /creditors
  def create
    @creditor = Creditor.new(creditor_params)
    @creditor.resolve_address
    
    if @creditor.save
      flash[:success] = 'Creditor was successfully created.'
      flash[:warning] = 'Address failed to be resolved. Creditor geo assignment will not be possible as a result.' if !@creditor.geocoded?
      redirect_to @creditor
    else
      render action: 'new'
    end
  end


private
    # Only allow a trusted parameter "white list" through.
    def creditor_params
      params.require(:creditor).permit(:name, :logo_resource_id, :enabled, 
                    :address, :city, :zipcode, :state_id, :country_id,
                    :phone, :fax, :website, :notes)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_creditor
      @creditor = Creditor.find(params[:id])
    end
end