
class AgenciesController < AccountsController
	load_and_authorize_resource :agency

	add_breadcrumb "Agencies", :agencies_path

	def show
		#@json = @account.to_gmaps4rails
		# TODO: authorize the sub elements
		add_breadcrumb @account.name, agency_path
		@price_models = @account.price_models.paginate(per_page: 10, page: params[:page])
		@account_reviews = @account.reviews.order("created_at desc").paginate(per_page: 5, page: params[:page])
		@account_reviews_numnber = @account.reviews.length

		# TODO: some statistics. needs to be precalcualted and cached
		relevent_debts = Debt.joins(:placements).where("debt_placements.agency_id = #{@account.id}", 'accepted_at is not null')
		stat_hash = Hash.new(0)
		relevent_debts.each { |d| stat_hash [ "#{Debts::Segment.short_text(d.debt_segment_id)} (#{Debts::Type.get_name(d.debt_type_id)})" ] += 1}
		@statistics = {by_segment: stat_hash}

		values = []		
		relevant_debt_placements = Debts::Placement.joins(:debt).where("agency_id =  #{@account.id} and accepted_at is not null")
		relevant_debt_placements.each { | p | 
			total_payments = p.payments.sum {| payment| payment.amount.amount }
			values << (100.0* total_payments / relevent_debts.find(p.debt_id).amount.amount)
		}

		@statistics[:payments] = Analytics.bucketize([0,20,50,80,100], values)
	end

	# PATCH/PUT /agency/1
	def update
		# first we update without saving
		@account.attributes = agency_params

		# now if something changed in the address we resolve it again
		@account.resolve_address if (@account.full_address_changed? || !@account.geocoded?)

		if @account.save
		  	flash[:success] = 'Agency was successfully updated.'
		  	flash[:warning] = 'Address failed to be resolved. Agency geo assignment will not be possible as a result.' if !@account.geocoded?
			redirect_to edit_agency_path(@account)
		else
			render action: 'edit'
		end
	end

	# GET /agencies/new
  	def new
    	@account = Agency.new
    	@account.agency_services.build
    	@account.agency_contracts.build
    	@account.country_id = Country.lookup(:'united states')
    	@agency = @account
    	add_breadcrumb "New"
  	end

  	# POST /agencies
	def create
		@account = Agency.new(agency_params)
		@account.resolve_address
		
		if @account.save
		  flash[:success] = 'Agency was successfully created.'
		  flash[:warning] = 'Address failed to be resolved. Agency geo assignment will not be possible as a result.' if !@account.geocoded?
		  redirect_to edit_agency_path(@account)
		else
		  render action: 'new'
		end
	end

private
    # Only allow a trusted parameter "white list" through.
    def agency_params
	  if (params[:agency][:agency_services_attributes].nil?)
	  	set_account
		params[:agency][:agency_services_attributes] = []
	  	convert_services_param(:consumer)
	  	convert_services_param(:commercial)
	  end

      params.require(:agency).permit(:name, :enabled, :verified, 
      				:address, :city, :zipcode, :state_id, :country_id, 
      				:email, :contact_name, :phone, :fax, :website,
      				:notes, :logo_resource_id, agency_services_attributes:
      				[:id, :_destroy, :debt_type_id, :debt_segment_id],
      				price_models_attributes: 
      				[:id, :enabled, :name,  :min_amount, :max_amount, :min_age, :max_age, :fee_precentage, :_destroy],
      				agency_contracts_attributes: [:id, :content])
    end

    def convert_services_param(type)
    	symbol = "agency_#{type.to_s}_services".to_sym
    	if params[:agency][symbol]
			ids = Hash[params[:agency][symbol].split(',').map {|x| [x.to_i, true]}]

		  	# existing services
			if (@account)
			  	services = @account.services(type)

				services.each do | s |
					params[:agency][:agency_services_attributes] << 
							{"id" => s.id.to_s, "_destroy" => (!ids[s.debt_segment_id]).to_s, 
								"debt_type_id" => Debts::Type.lookup(type).to_s, 
								"debt_segment_id" => s.debt_segment_id.to_s}

					ids.delete(s.debt_segment_id)
				end
			end

			# new services
			ids.each do | id, k |
				params[:agency][:agency_services_attributes] << 
							{"id" => nil.to_s, "_destroy" => "false", 
								"debt_type_id" => Debts::Type.lookup(type).to_s, 
								"debt_segment_id" => id.to_s }
			end
		end
    end
end