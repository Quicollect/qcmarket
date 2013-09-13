module Debts
	class DebtShoppinglistItemsController < ApplicationController
		load_and_authorize_resource class: Debts::DebtShoppinglistItem
	  	before_action :set_debt

		def create
			@shoppinglist_item = @debt.debt_shoppinglist_items.new(debts_debt_shoppinglist_item_params)
			@shoppinglist_item.account_id = current_user.account_id
			@shoppinglist_item.shoppinglist_item_status_id = Debts::ShoppinglistItemStatus.lookup(:listed)
			
			@agency = Agency.find(@shoppinglist_item.agency_id)
			# TODO: check if we need to add validation that debt belongs to the user

			@success = false
		    if @shoppinglist_item.save
		      create_event(@debt.id, :update, ["Adding agency '#{@agency.name}' as potential service provider", "Description: #{@shoppinglist_item.description}"], true)
		      @success = true
		  	end

		    respond_to do |format|
			  format.js { 
			  		render partial: "debts/debt_shoppinglist_items/index", locals: { debt: @debt, success: @success, add: true } 
			  	}
			end
		end

		def destroy
			@shoppinglist_item = Debts::DebtShoppinglistItem.find(params[:id])
			@agency = Agency.find(@shoppinglist_item.agency_id)
			
			@success = false
		    if @shoppinglist_item.destroy
		      create_event(@debt.id, :update, ["Removing agency '#{@agency.name}' as potential service provider"], true)
		      @success = true
		    end

		    respond_to do |format|
			  format.js { 
			  		render partial: "debts/debt_shoppinglist_items/index", locals: { debt: @debt, success: @success, add: false } 
			  	}
			end
		end

	private
	    def set_debt
	      @debt = Debts::Debt.find(params[:debt_id])
	    end

	   	def debts_debt_shoppinglist_item_params
	    	params.require(:debts_debt_shoppinglist_item).permit(:agency_id, :description)
	  	end
	end
end


