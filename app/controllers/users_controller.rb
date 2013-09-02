class UsersController < ApplicationController
  
  load_and_authorize_resource :user
  respond_to :html, :json, :xml

  helper_method :sort_column, :sort_direction

  before_filter do
    if can_with_sample? :index
      add_breadcrumb "Users", :users_path
    end
  end

  def new
  	@user = User.new(account_id: current_user.id)
    add_breadcrumb "New"
    render 'edit'
  end

  def show
    @user = User.find(params[:id])
    add_breadcrumb @user.name

    render 'edit'
  end

  def edit
    @user = User.find(params[:id])
    add_breadcrumb @user.name
  end


  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted successfully."
    redirect_to users_url
  end

  def index
    authorize_sample! :index

    @users = viewable_objects.order(sort_column + " " + sort_direction).search(params[:search]).paginate(per_page: 10, page: params[:page])
  end

  def switch_index
    @users = viewable_objects({user:current_user.original_user}).order(sort_column + " " + sort_direction).search(params[:search]).paginate(per_page: 10, page: params[:page])
  end

  def create
    @user = User.new(user_params)

    # if user is not admin, he can only create users in his own account
    @user.account_id = current_user.account_id if (!current_user.is_admin?)

    safe_roles_update(@user)

    if @user.save
      flash[:notice] = "Successfully created user #{@user.name}."
      redirect_to users_path
    else
      render :action => 'edit'
    end

  end

  def update
    @user = User.find(params[:id])
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password].blank? and params[:user][:password_confirmation].blank?
    
    safe_roles_update(@user)
    params[:user].delete :roles

    if @user.update_attributes(params[:user])
      flash[:notice] = "Successfully updated user #{@user.name}."
      redirect_to root_path
    else
      render :action => 'edit'
    end
  end

private
  def user_params
  	params.require(:user).permit(:name, :email, :password, :password_confirmation, :account_id, {roles: []})
  end

  def safe_roles_update(user)
    # we only allow roles which the owner has to be assigned to the new one
    user.roles = {}
    user_params[:roles][0].split(',').each do |role|
      if (current_user.has_role? role)
        user.roles << role
      end
    end
  end
end
