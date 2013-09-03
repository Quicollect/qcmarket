class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # this is to allow us to override the default strong_param permit
  before_filter do
    resource = controller_path.singularize.gsub('/', '_').to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  before_filter do
    authenticate_user!

    # default is always to allow switch back (switch_user gem)
    provider = SwitchUser::Provider.init(self)
    if (current_user)
      provider.remember_current_user(true) if !provider.original_user.present?
      current_user.original_user = provider.original_user
    end
  end

  before_filter do 
    set_locale
    add_breadcrumb I18n.t('menus.home'), '/'
  end

  after_filter do
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    redirect_to root_path, :alert => exception.message
  end

  helper :all

  # overriding default after sign_in_path
  def after_sign_out_path_for(resource)
    sign_in_path
  end

  # check if there is a path the user initialy used and redirect to it after login
  def after_sign_in_path_for(resource)
    # first time - take to a special welcome page
    if current_user.sign_in_count == 1
      welcome_path
    elsif !session[:user_return_to].nil?
      session[:user_return_to].to_s
    else
      root_path 
    end
  end

  def validate_ownership(resource)
    current_account.id == resource.account_id
  end
  
  def authorize_sample!(symbol)
    authorize! symbol, get_class.new(account_id: current_user.account_id)
  end

  def can_with_sample?(symbol)
    can? symbol, get_class.new(account_id: current_user.account_id) 
  end

  def viewable_objects(options={})
    # init options
    options[:user] = current_user if !options[:user]
    options[:id_column] = "account_id" if !options[:id_column]
    options[:cls] = get_class if !options[:cls]

    # check if entity has a logical delete

    conditions = "#{options[:id_column]} = #{options[:user].account_id}"
    conditions += " and deleted = false" if options[:cls].respond_to? 'find_by_deleted'
    
    options[:user].is_admin?  ? options[:cls].all : options[:cls].where(conditions)
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def sort_column
    model_class.column_names.include?(params[:sort]) ? params[:sort] : "id"
  end

  def model_class
     model_name.constantize
  end

  def model_name
    self.class.name.sub("Controller", "").singularize.classify
  end

  def get_class
    controller_path.classify.constantize
  end 

  def default_url_options(options={})
    { locale: I18n.locale }
  end

protected
  def set_locale
    # TODO: add from current_user setttings
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def add_breadcrumb name, url = ''
    @breadcrumbs ||= []
    url = eval(url.to_s) if url =~ /_path|_url|@/
    @breadcrumbs << [name, url]
  end
 
  def self.add_breadcrumb name, url, options = {}
    before_filter options do |controller|
      controller.send('add_breadcrumb', name, url)
    end
  end

    # TODO: need to move to be async + make generic not just debt events
  def create_event(id, type, text_arr = [])
    text = ""
    if (text_arr.length > 0)
      text_arr.unshift ('The following has been changed:')
      text = text_arr.join('%%%')
    end

    Timeline::DebtEvent.create(event_type: Timeline::EventType.find_by_name(type).id,
                               user_id: current_user.id,
                               account_id: current_user.account_id,
                               text: text,
                              entity_id: id,
                              :private => false)
  end
end
