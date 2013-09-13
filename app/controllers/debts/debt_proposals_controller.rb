module Debts
	class DebtProposalsController < ApplicationController
	  	before_action :set_objects

	  	def new
	  		authorize! :edit, @debt
	  		@agency = Agency.find(@item.agency_id)
	  		render partial: 'new'
	  	end

	  	def create
	  		authorize! :edit, @debt
	  		@agency = Agency.find(@item.agency_id)

	  		SystemMailer.request_for_proposal(@debt, @agency.email).deliver
	  		@item.update!(shoppinglist_item_status_id: Debts::ShoppinglistItemStatus.lookup(:contacted))
	  		create_event(@debt.id, :notification, ["Debt opportunity was sent to #{@agency.name} (via #{@agency.email})"])
		    flash[:success] = 'Debt opportunity was successfully sent.'
		    redirect_to debt_path(@debt)
	  	end

	private
	    def set_objects
	      @debt = Debts::Debt.find(params[:id])
	      @item = Debts::DebtShoppinglistItem.find(params[:item_id])
	    end
	end
end