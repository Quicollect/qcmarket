module Debts
  class DebtsController < ApplicationController
    prepend_view_path 'app/views'
    
    load_and_authorize_resource class: Debts::Debt
    before_action :set_debt, only: [:show, :edit, :update, :destroy]

<<<<<<< HEAD
    before_filter do 
      add_breadcrumb I18n.t('menus.debts'), :debts_path
    end
=======
    add_breadcrumb "Debts", :debts_path
>>>>>>> e74b7e8... first commit to the market place app

    helper_method :sort_column, :sort_direction


    # list all debts (by pages)
    def index
      # check if supports index at least for its own debts
      authorize_sample! :index

      @debts = viewable_objects.order("debts." + sort_column + " " + sort_direction).search(params[:search]).paginate(per_page: 10, page: params[:page])
      
      # TODO: take this out of here, it looks ugly, needs some warpping
      @debt_statistics = {}
      pending_debts = viewable_objects.where(deleted: false).where.not(debt_status_id: Debts::DebtStatus.lookup(:closed)).where.not(debt_status_id: Debts::DebtStatus.lookup(:resolved))
      @debt_statistics[:total_pending] = pending_debts.length
      @debt_statistics[:total_pending_amount] = pending_debts.to_a.sum{|x| x.amount-x.amount_paid}

      paid_debts = viewable_objects.where("debt_status_id in (#{Debts::DebtStatus.lookup(:closed)}, #{Debts::DebtStatus.lookup(:resolved)})")
      @debt_statistics[:total_resolved] = paid_debts.length
      @debt_statistics[:total_resolved_amount] = paid_debts.to_a.sum{|x| x.amount}
      @debt_statistics[:total_resolved_amount_paid] = paid_debts.to_a.sum{|x| x.amount_paid}
      if (@debt_statistics[:total_resolved_amount] > 0)
        @debt_statistics[:total_resolved_precentage] = (100*@debt_statistics[:total_resolved_amount_paid].amount/@debt_statistics[:total_resolved_amount].amount).round(0)
      else
        @debt_statistics[:total_resolved_precentage] = 0
      end  
      @debt_statistics[:total] = viewable_objects.length
    end

    # map all debts 
    def map
      authorize_sample! :map

      @json = viewable_objects.to_gmaps4rails

      add_breadcrumb "Map All"
    end

    def show
      add_breadcrumb @debt.title, debt_path

      load_debt_history
    end

    # GET /debts/new
    def new
      @debt = Debts::Debt.new(account_id: current_user.account_id, debt_status_id: Debts::DebtStatus.lookup(:draft))
<<<<<<< HEAD
      @debt.id = -1
=======
>>>>>>> e74b7e8... first commit to the market place app
      add_breadcrumb 'New'
      render 'edit'
    end

    # GET /debts/1/edit
    def edit
      add_breadcrumb @debt.title, debt_path
    end

    # POST /debts
    def create
      @debt = Debts::Debt.new(debts_debt_params)
      @debt.account_id = current_user.account_id
      @debt.resolve_address
      @debt.status = :draft

      if @debt.save
        create_event(@debt.id, :creation)
        flash[:success] = 'Debt was successfully created.'
        redirect_to debts_url
      else
        render action: 'edit'
      end
    end

    def status_change
      new_status_id = params[:debt_event][:debt_status_id].to_i
      note = params[:debt_event][:note]

      # now we check the logic of changes in status
      if (@debt.allowed_actions.include? Debts::DebtStatus.symbol(new_status_id))
          @debt.debt_status_id = new_status_id

          # note that using "last" will fail the autosave of the nested attribute
          @debt.last_placement.active = false if [:rejected, :resolved].include?(Debts::DebtStatus.symbol(new_status_id))
          
          update_text = update_details(@debt)
          if @debt.save
            create_event(@debt.id, :statuschange, [ update_text, "Notes: " + note ])
            flash[:success] = 'Debt was successfully updatded.'
            redirect_to debt_path(@debt)
          else
            render action: 'show'
          end
      else
        Rails.logger.warn "QC | Trying to change debt status from #{@debt.was_debt_status_id} to #{new_status_id} not allowed"
        flash[:error] = 'Operation not allowed'
        render action: 'show'
      end

    end

    # PATCH/PUT /debts/1
    def update
      @debt.attributes = debts_debt_params
      

      update_text = update_details(@debt)

      # now if something changed in the address we resolve it again
      @debt.resolve_address if (@debt.full_address_changed? || !@debt.geocoded?)

      if @debt.save
        create_event(@debt.id, :update, update_text)
        flash[:success] = 'Debt was successfully updatded.'
        redirect_to debt_path(@debt)
      else
        render action: 'edit'
      end
    end

    # DELETE /debts/1
    def destroy

      # logical delete
      @debt.deleted = true
      if @debt.save
        create_event(@debt.id, :delete)
        flash[:success] = 'Debt was successfully deleted.'
      end

      redirect_to debts_url
    end

      # find x closest agencies from a given location
    def find

      # if address wasn't resolved yet we do it now
      if (!@debt.geocoded?)
        Rails.logger.info "QC | Resolving address for Debt #{@debt.id}"

        @debt.resolve_address

        if (@debt.geocoded?)
          @debt.save  
        else
          Rails.logger.warn "QC | Resolving address for Debt #{@debt.id} failed"
          flash[:error] = 'Unable able to located debt address at this time.'
          return redirect_to @debt
        end
      end
      
      Rails.logger.debug "QC | trying to locate agencies for Debt #{@debt.id}"

      # fetch the relevant close by agencies
      @results = _get_closest_results(5, params[:page], @debt)
      
      # create the json for the map display
      @map_results = @results.collect{|a| a[:agency]}
      @map_results << @debt
      @json = @map_results.to_gmaps4rails

      add_breadcrumb @debt.title, debt_path
      add_breadcrumb "Find Agencies"

      render 'show'
    end


    def resources
      respond_to do |format|
        format.json { render json: {files: @debt.resources.collect{|r| r.to_jq_resource}.to_json}, status: :ok  }
      end
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_debt
      @debt = Debts::Debt.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def debts_debt_params
      params.require(:debts_debt).permit(:title, :debt_type_id, :debt_segment_id,
            :charge_date, :amount, :amount_currency, :description, 
            :address, :city, :zipcode, :state_id, :country_id, :phone, :fax, :email,
            debt_files_attributes: [:id, :_destroy, :resource_id])
    end

    def viewable_objects
      Debts::Debt.viewable_debts(current_user)
    end

    def load_debt_history
      # load history
      @debt_events = Timeline::DebtEvent.where(entity_id: @debt.id).order("id desc")
    end

    def update_details(debt)
      members = [:title, :charge_date, :description,
                :address, :city, :zipcode, 
                :phone, :fax, :email]
      
      text = []
      members.each do | member |
        now = "debt.#{member.to_s}"
        was = "#{now}_was"
        text << "#{member.to_s.humanize}: from '#{eval(was)}' to '#{eval(now)}'" if eval("debt.#{member}_changed?")
      end

      members = [:debt_type_id, :debt_status_id, :debt_segment_id, :state_id, :country_id]
      members.each do | member |
        str = member.to_s.sub '_id', ''
        cls = str.include?('debt_') ? "Debts::#{str.classify}".constantize : str.classify.constantize
        
        now = "debt.#{member.to_s}"
        was = "#{now}_was"
        text << "#{member.to_s.humanize}: from '#{cls.symbol(eval(was)).to_s}' to '#{cls.symbol(eval(now)).to_s}'" if eval("debt.#{member}_changed?")
      end

      members = [:amount]
      members.each do | member |
        now = "debt.#{member.to_s}"
        was = "#{now}_was"
        text << "#{member.to_s.humanize}: from '#{eval(was).to_s_with_currency}' to '#{eval(now).to_s_with_currency}'" if eval("debt.#{member}_changed?")
      end

      text
    end
    
    def _get_closest_results(num_of_results, page, debt)

      # create the points list
      results = []

      # first look inside the same country
      results = _get_agencies_distance(debt, debt.country_id)

      # if nothing found we look for any match
      results = _get_agencies_distance(debt, nil) if results.length == 0

      start_index = (num_of_results)*(page.nil? ? 0 : page.to_i-1)

      results.paginate(page: page, per_page: num_of_results)
    end

    def _get_agencies_distance(debt, country_id)
      results = []
      
      age = (DateTime.now - debt.charge_date).floor
      amount = debt.amount

      # we first look for relevant price models
      price_models = PriceModel.find_match(country_id, debt.debt_type_id, amount, age)

      services = AgencyService.find_support(price_models.collect{|a| a.id}, debt.debt_segment_id, debt.debt_type_id)

      # now we iterate over the agencies to calc destination
      the_agencies = Agency.where(id: services.collect{|s| s.agency_id})

      the_agencies.find_each do | agency |
        if (agency.geocoded?)
          agency.distance = debt.distance_to(agency)
          price_model = price_models.where(agency_id: agency.id).limit(1)[0]
          results << {agency: agency, price_model: price_model}
        end
      end

      results = results.sort_by{|a| a[:agency].distance}
      return results
    end
  end
end