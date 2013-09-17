class CreditorsController < AccountsController
  load_and_authorize_resource :creditor  

  add_breadcrumb "Creditors", :creditors_path


  def show
    add_breadcrumb @creditor.name
    render 'edit'
  end

   # GET /creditors/new
  def new
    @account = Creditor.new
    add_breadcrumb "New"
    render 'edit'
  end

  # PATCH/PUT /creditor/1
  def update
    # first we update without saving
    @account.attributes = creditor_params

    # now if something changed in the address we resolve it again
    @account.resolve_address if (@creditor.full_address_changed? || !@creditor.geocoded?)

    if @account.save
      flash[:success] = 'Creditor was successfully updated.'
      flash[:warning] = 'Address failed to be resolved. Creditor geo assignment will not be possible as a result.' if !@creditor.geocoded?
      redirect_to @account
    else
      render action: 'edit'
    end
  end

    # POST /creditors
  def create
    @account = Creditor.new(creditor_params)
    @account.resolve_address
    
    if @account.save
      flash[:success] = 'Creditor was successfully created.'
      flash[:warning] = 'Address failed to be resolved. Creditor geo assignment will not be possible as a result.' if !@creditor.geocoded?
      redirect_to @account
    else
      render action: 'edit'
    end
  end


protected
    # Only allow a trusted parameter "white list" through.
    def creditor_params
      account_params
    end
end