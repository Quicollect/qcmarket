class Ability
  include CanCan::Ability

  # See the wiki for details:
  # https://github.com/ryanb/cancan/wiki/Defining-Abilities

  def initialize(user)
     user ||= User.new # guest user

    # admin can do everything
    if user.has_role? :admin
        can :manage, :all
    else
        can :reset, User # for password reset
    end
    
    # and for switching users we look at the original user
    if user.original_user.has_role? :admin
        can [:switch_index], User
    end

    # account admin can manage his own account users & his own account
    if user.has_role? :account_admin
        can [:manage], User do |u|
            u.account_id == user.account_id
        end

        can [:read, :update], [Account, Agency, Creditor] do |a|
            a.id == user.account_id
        end
    end

    # agency can view his own account data and manage resources
    if user.has_role? :agency
        can [:read], [Agency, Account] do |account|
            account.id == user.account_id
        end
        
        # only debts which are assigned to it
        can [:read, :index, :status_change], Debts::Debt do | debt |
            debt.account_id == user.account_id || Debts::DebtPlacement.exists?(active: true, debt_id: debt.id, agency_id: user.account_id)
        end

        # only events which belongs to debt assign to it
        can [:read, :create, :index], Timeline::DebtEvent do | event |
            event.account_id == user.account_id || Debts::DebtPlacement.exists?(active: true, debt_id: event.entity_id, agency_id: user.account_id)
        end

        # can manage their own debt placements
        can [:read, :create, :update], [Debts::DebtPlacement] do | placement |
            placement.agency_id == user.account_id
        end

        # can manage their own debt payments
        can [:read, :create, :update], [Debts::DebtPayment] do | payment |
            supported = true
            if (payment.debt_id)
                debt_placement = Debts::Debt.find(payment.debt_id).current_active_placement
                supported = debt_placement && debt_placement.agency_id == user.account_id
            end

            supported
        end
 
        can [:manage], [Resource, Document] do |resource|
            resource.account_id == user.account_id
        end



        # for the account_admin - he can also change the price models
        if user.has_role? :account_admin
            can [:manage], [PriceModel, AgencyService] do |obj|
                obj.agency_id == user.account_id
            end
        else
            can [:read, :index], [PriceModel, AgencyService] do |obj|
                obj.agency_id == user.account_id
            end
        end
    end

    # creditor abilities
    if user.has_role? :creditor
        can [:manage], [Debts::Debt, Resource, Document, Debts::DebtShoppinglistItem] do |obj|
            (obj.account_id == user.account_id) || !obj.account_id
        end

        cannot :destroy, Debts::Debt do | obj |
            !obj.deletable?
        end

        can [:manage], [Timeline::Event] do |obj|
            (obj.account_id == user.account_id) || !obj.account_id
        end

        can [:read], [Agency, Account]

        # can manage his own reviews & read all others
        can [:manage], [Review] do |review|
            review.user_id == user.id || !review.user_id
        end

        can [:read], Review

        # can see debt events only if belongs to the creditor debts
        can [:read, :create, :index], Timeline::DebtEvent do | event |
            Debts::Debt.find(event.entity_id).account_id == user.account_id
        end
    end


    # user role can manage his own user & and view his own account
    if user.has_role? :user
        can [:read, :update], User do |u|
            u.id == user.id
        end

        can [:read], [Creditor, Account, Agency] do |a|
            a.id == user.account_id
        end

        can [:manage], [Resource, Document] do |r|
            r.id == user.account_id
        end

        # lookup values are always accessible via read
        # note this this is not critical as the code never tries to authorize them
        can [:read], [Debts::DebtSegment, Debts::DebtType, Country]
    end

    # guests can create new users only by letting the system assign them a new account
    can :create, User, account_id: nil

    # things no one can do
    cannot :delete, User do | u |
        Rails.logger.info "QC | trying to delete #{u.id} by #{user.id}"
        u.id == user.id
    end

    cannot :delete, Debts::Debt do | obj |
        !obj.deletable?
    end

  end
end
