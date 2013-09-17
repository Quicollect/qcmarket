class Debts::ProposalsController < ApplicationController
    skip_before_filter :authenication_process, only: [:show, :accept]

  	before_action :set_objects, only: [:new, :create]

    before_filter do 
      add_breadcrumb I18n.t('menus.debts'), :debts_path
    end

  	def new
  		authorize! :edit, @debt
  		@agency = Agency.find(@item.agency_id)
  		render partial: 'new'
  	end

  	def create
  		authorize! :edit, @debt
      # TODO: change the default expirtion to conf
  		@agency = Agency.find(@item.agency_id)
      @proposal = @debt.proposals.new(item_id: @item.id, 
                key: SecureRandom.urlsafe_base64(20), expires: DateTime.now+7)
      
      if @proposal.save
        SystemMailer.request_for_proposal(@debt, @proposal, @agency).deliver
        create_event(@debt.id, :notification, ["Debt opportunity was sent to #{@agency.name} (via #{@agency.email})"], {:private => true})
        flash.now[:success] = 'Debt opportunity was successfully sent.'
      end

	    redirect_to debt_path(@debt)
  	end

    def show
      @proposal = Debts::Proposal.find_by_key(params[:key])
      if !@proposal || @proposal.expires < DateTime.now
        render 'expired'
        return
      end

      @debt = Debt.find(@proposal.debt_id)
    end

    def accept
      @proposal = Debts::Proposal.find_by_key(params[:debts_proposal][:key])
      if !@proposal || @proposal.expires < DateTime.now
        render 'expired'
        return
      end

      @item = @proposal.shoppinglist_item
      @agency = Agency.find(@item.agency_id)
      @debt = Debt.find(@item.debt_id)
      
      if @proposal.update(accepted: true)
        SystemMailer.debt_details(@debt, @agency).deliver
        create_event(@debt.id, :statuschange, ["Debt opportunity was accepted by #{@agency.name}. Full debt details were sent to #{@agency.email}"],
                {:private => true, user: User.new(account_id: @agency.id)})
      end
    end

private
    def set_objects
      @debt = Debt.find(params[:debt_id])
      @item = Debts::ShoppinglistItem.find(params[:item_id])
    end
end
