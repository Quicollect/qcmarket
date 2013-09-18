class DocumentsController < ApplicationController
  
  load_and_authorize_resource :document
  before_action :set_account
  before_action :set_document, only: [:show, :edit, :update, :destroy]

  add_breadcrumb I18n.t("menus.documents"), :documents_path

  helper_method :sort_column, :sort_direction

  def index
    # check if supports index at least for its own resources
    authorize_sample! :index

    per_page = [18, params[:per_page] ? params[:per_page].to_i : 18].min
    filtered_documents = viewable_objects.order("id desc").search(params[:search])
    @documents = filtered_documents.paginate(per_page: per_page, page: params[:page])
    
    respond_to do |format|
      format.html
      format.json { render "documents/index.json"  }
      format.js { render "documents/index.js"  }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document }
    end
  end

  def destroy
    @document.destroy

    respond_to do |format|
      format.html { redirect_to documents_path }
      format.json { head :no_content }
    end
  end


private

  # Use callbacks to share common setup or constraints between actions.
  def set_document
    @document = Document.find(params[:id])
  end

  def set_account
    if (current_user.account_id == 0) # master account
      @account = Account.new(id: 0)
    else
      @account = Account.find(current_user.account_id) #params[:agency_id]
    end
  end
end
