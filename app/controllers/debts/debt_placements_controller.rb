module Debts
	class DebtPlacementsController < ApplicationController
		load_and_authorize_resource class: Debts::DebtPlacement
	  	before_action :set_debt

		def new
			@debt_placement = @debt.debt_placements.new(debts_debt_placement_params)
			@debt_placement.price_model_id = PriceModel.find_by_agency(@debt, @debt_placement.agency_id).first.id
			@agency_contract = Agency.find(@debt_placement.agency_id).current_contract
			render partial: 'new'
		end

		def create
			if (!@debt.allowed_actions.include? :assigned)
				flash[:error] = 'Cannot assign/re-assign debt at its current state.'
				redirect_to debt_path(@debt)
				return
			end

			@debt.debt_status_id = Debts::DebtStatus.lookup(:assigned)
		    @debt.debt_placements.each do | p |
		      p.active = false
		    end

			# TODO add validations that account is agency, price model belongs to it etc.
			# that price model is enabled etc.
			@agency = Agency.find(params[:debts_debt_placement][:agency_id])
			@price_model = @agency.price_models.find(params[:debts_debt_placement][:price_model_id])
			
			if (@price_model.id != PriceModel.find_by_agency(@debt, @agency.id).first.id)
				flash[:error] = 'Cannot assign debt. Mismtach between price models accepted than one assigned by the system.'
				redirect_to debt_path(@debt)
				return
			end

			@agency_contract = @agency.agency_contracts.find(params[:debts_debt_placement][:agency_contract_id])

			# this should not happen but can if someone updated the contact while someone
			# was creating a new palcement. we only warn to log at this stage
			if !@agency_contract.active
				Rails.logger.warn "QC | debt placement was created with an older contract #{@agency_contract.id}"
			end
	    
		    @debt.debt_placements.new(agency_id: @agency.id,
		                              price_model_id: @price_model.id,
		                              agency_contract_id: @agency_contract.id,
		                              active: true)
		    if @debt.save
		      create_event(@debt.id, :statuschange, ["Debt was assigned to agency #{@agency.name.upcase} (#{@agency.id})"])
		      flash[:success] = 'Debt was successfully assigned to agency.'
		    end

		    redirect_to debt_path(@debt)
		end

	private
	    def set_debt
	      @debt = Debts::Debt.find(params[:debt_id])
	    end

	   	def debts_debt_placement_params
	    	params.require(:debts_debt_placement).permit(:agency_id, :agency_contract_id, :price_model_id)
	  	end
	end
end


