class AccountsController < ApplicationController
	before_action :set_account, only: [:show, :edit, :update, :destroy]

	helper_method :sort_column, :sort_direction

	# list all agencies (by pages)
	def index
		authorize! :index, model_class.new

		@resources = model_class.order(sort_column + " " + sort_direction).search(params[:search]).paginate(per_page: 10, page: params[:page])
		
		respond_to do |format|
		  format.html { render 'accounts/index' }
		  format.json { render 'accounts/index' }
		  format.js { 
		  		render partial: "accounts/index", locals: { resources: @resources, resource_name: model_name.downcase } 
		  	}
		end
	end

	def show
		authorize! :show, @account
		render 'edit'
	end

	def edit
		authorize! :edit, @account
		add_breadcrumb @account.name, eval(model_name.downcase + "_path")
		add_breadcrumb 'Edit'
	end

	def update
		authorize! :update, @account

		# first we update without saving
		@account.attributes = account_params

		# now if something changed in the address we resolve it again
		@account.resolve_address if (@account.full_address_changed? || !@account.geocoded?)

		if @account.save
		  flash[:success] = "#{model_name} was successfully updated."
		  flash[:warning] = "Address failed to be resolved. #{model_name} geo assignment will not be possible as a result." if !@account.geocoded?
		  redirect_to @account
		else
		  render action: 'edit'
		end
	end
	
	def map
		authorize! :map, model_class.new
    
		@json = model_class.all.to_gmaps4rails
		@title =  plural_name

		add_breadcrumb "Map All"
		render 'accounts/map'
	end
	
	def destroy
		authorize! :destory, @account

		@account.destroy
	    flash[:success] = "#{@account.class} was successfully deleted."
	    redirect_to root_path
	end

private	
	def plural_name
		self.class.name.sub("Controller", "")
	end

	def redirect_url(action, prefix)
		authorize! action, model_class.new

		action_url = nil

		# we redirect to the right child controller
		a = Account.find(params[:id])
			
		if (a.accountable_type.downcase != "account")
			action_url = prefix + "_" + a.accountable_type.downcase + "_path #{a.id}"
		end
		
		action_url
	end

	# Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id]) if params[:id]
    end

    # Only allow a trusted parameter "white list" through.
    def account_params
      params.require(model_name.downcase.to_sym).permit(:name, :logo_resource_id, :enabled, 
                    :address, :city, :zipcode, :state_id, :country_id,
                    :phone, :fax, :website, :notes)
    end
end
