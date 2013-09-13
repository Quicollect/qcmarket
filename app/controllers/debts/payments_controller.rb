class Debts::PaymentsController < ApplicationController
	load_and_authorize_resource
  	before_action :set_debt

  	include CurrenciesHelper

	def new
		@debt_payment = @debt.payments.new(debt_placement_id: @debt.placements.last.id)
		render partial: 'new'
	end

	def create
		@debt_payment = @debt.payments.new(debts_payment_params)
		@debt_payment.amount_currency = @debt.amount_currency

		if (!@debt.placements.last.active)
			flash[:error] = 'Cannot add payment for debt without an active placement'
			render partial: 'new'
			return
		end
		
		# TODO: need to add some validations
		@debt_payment.debt_placement_id = @debt.placements.last.id
		@debt.amount_paid += @debt_payment.amount

	    if @debt.save
	      create_event(@debt.id, :update, ["Debt payment #{@debt_payment.payment_date > DateTime.now ? 'will be' : 'was'} recieved on #{@debt_payment.payment_date} for the amount of #{@debt_payment.amount.to_s_with_currency}", "Description: #{@debt_payment.description}"])
	      flash[:success] = 'Debt payment was successfully created.'
	      redirect_to debt_path(@debt)
	    else
	      render partial: 'new'
	    end
	end

private
    def set_debt
      @debt = Debt.find(params[:debt_id])
    end

   	def debts_payment_params
    	params.require(:debts_payment).permit(:payment_date, :amount, :description)
  	end
end


