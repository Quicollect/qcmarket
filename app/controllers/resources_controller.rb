class ResourcesController < ApplicationController
  
  # this for some reason mess up the upload
  #load_and_authorize_resource :resource
  before_action :set_account
  before_action :set_resource, only: [:show, :edit, :update, :destroy]


  def index
    # doesn't return anything - do not change(!)
    respond_to do |format|
      format.html
      format.json { head :no_content }
    end
  end

  def show
    @resource = Resource.find(params[:id])
    authorize! :read, @resource

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @resource }
    end
  end


  def new
    authorize! :create, Resource

    @resource = Resource.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @resource }
    end
  end

  def edit
    @resource = Resource.find(params[:id])
    authorize! :update, @resource
    
  end

  def create
    authorize! :create, Resource
    @resource = Resource.new(resource_params)
    @resource.account_id = current_user.account_id
    @resource.display_name = params[:display_name]
    @resource.resource_file_name = "#{Resource.random_file_name}#{Rack::Mime::MIME_TYPES.invert[@resource.resource_content_type]}"

    respond_to do |format|
      if @resource.save
        format.html {
          render :json => [@resource.to_jq_resource].to_json,
          :content_type => 'text/html',
          :layout => false
        }
        format.json { 
          render json: {files: [@resource.to_jq_resource]}, status: :created, location: @resource 
        }
      else
        format.html { render action: "new" }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @resource = Resource.find(params[:id])
    @resource.account_id = current_user.account_id
    authorize! :update, @resource

    respond_to do |format|
      if @resource.update_attributes(resource_params)
        format.html { redirect_to @resource, notice: 'Resource was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @resource = Resource.find(params[:id])
    authorize! :destroy, @resource

    str = @resource.to_jq_resource

    @resource.destroy

    respond_to do |format|
      format.html { redirect_to resources_url }
      format.json { head :no_content  }
    end
  end

private

  def resource_params
    params.require(:resource).permit(:resource)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_resource
    @resource = Resource.find(params[:id])
  end

  def set_account
    if (current_user.account_id == 0) # master account
      @account = Account.new(id: 0)
    else
      @account = Account.find(current_user.account_id) #params[:agency_id]
    end
  end
end
