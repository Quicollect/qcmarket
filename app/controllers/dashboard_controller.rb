class DashboardController < ApplicationController

  def home
      @user = current_user 
  end

  def welcome
  	@user = current_user
  end

  def dated_debts
    @resources = Debt.get_not_updated_since(current_user, DateTime.now-5).limit(5)
    ajax_respose
  end

  def non_reviewed_debts
    ownership_condition =  (current_user.is_admin? ? '' : "debts.account_id = #{current_user.account_id}")
    @resources = Debts::Placement.includes(:debt, :review).where('reviews.id is null').where('resolved_at is not null').where(ownership_condition).references(:reviews)
    ajax_respose
  end

  def recent_reviews
    @resources = viewable_objects({id_column: "agency_id", cls: Review}).order("updated_at desc").limit(5)
    ajax_respose
  end

  def recent_activities
    @resources = Timeline::DebtEvent.viewable(current_user).order("id desc").paginate(per_page: 4, page: params[:page])
    ajax_respose
  end

  def help
  end

  def about
  end

  def contact
  end

private 
  def ajax_respose
    respond_to do |format|
      format.js { 
          render partial: "widgets/response", locals: { resources: @resources } 
        }
    end
  end
end
