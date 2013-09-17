QCMarket::Application.routes.draw do

  root :to => 'dashboard#home'
  get 'welcome', to: 'dashboard#welcome', as: 'welcome'

  # widgets
  ['dated_debts', 'recent_activities', 'non_reviewed_debts', 'recent_reviews'].each do | path |
    get path, to: "dashboard##{path}", as: path
  end
  
  
  # for someone this doesn't work so we do it in the code
  #root :to => 'devise/sessions#new'
  devise_scope :user do 
    get 'sign_in' => 'devise/sessions#new'
    get 'sign_up' => 'registrations#new'
  end


  get 'switch_user', to: 'switch_user#set_current_user'
  get 'users/switch_index', to: 'users#switch_index', as: 'users_switch_index'
  
  devise_for :users, :path_prefix => 'reg', :controllers => {:registrations => "registrations"}

  resources :users

  # these needs to be first so the action isn't considered an id
  get "agencies/map"
  get "creditors/map"
  get "accounts/map"
  get "debts/map"

  resources :accounts
  resources :creditors
  resources :agencies, only: [:index, :show, :edit, :new, :update, :create, :destroy] do
    # we cancel this as an option. everything will be done through the agency controller
    resources :price_models
  end

  resources :documents
  resources :resources

  # placements
  get "debts/:debt_id/placements/new", to: 'debts/placements#new', as: 'new_debt_placement'
  post "debts/:debt_id/placements/create", to: 'debts/placements#create', as: 'debt_placements'

  # payments
  get "debts/:debt_id/payments/new", to: 'debts/payments#new', as: 'new_debt_payment'
  post "debts/:debt_id/payments/create", to: 'debts/payments#create', as: 'debt_payments'

  # reviews
  get "debts/:debt_id/placements/:placement_id/reviews/new", to: 'reviews#new', as: 'new_debt_placement_review'
  post "debts/:debt_id/placements/:placement_id/reviews", to: 'reviews#create', as: 'debt_placement_reviews'

  # shoppinglist
  delete "debts/:debt_id/shoppinglist_items/:id", to: 'debts/shoppinglist_items#destroy', as: 'debt_shoppinglist_item'
  post "debts/:debt_id/shoppinglist_items", to: 'debts/shoppinglist_items#create', as: 'debt_shoppinglist_items'
  
  # proposals
  get "debts/:debt_id/items/:item_id/proposal/new", to: 'debts/proposals#new', as: 'new_debt_proposal'
  post "debts/:debt_id/items/:item_id/proposals", to: 'debts/proposals#create', as: 'debt_proposals'
  get "debts/proposals/show", to: 'debts/proposals#show', as: 'show_debt_proposal'
  patch "debts/proposals/accept", to: 'debts/proposals#accept', as: 'accept_debt_proposal'



  #scope module: "debts" do 
    get "debts/find/:id", to: 'debts#find', as: 'find_debt_agency'
    post "debts/:id/status_change", to: 'debts#status_change', as: 'status_change_debt'

    resources :debts, only: [:index, :show, :edit, :new, :update, :create, :destroy]  do 
      #resources :placements, only: [:new, :create], path: "placements"
      #resources :payments, only: [:new, :create], path: "payments"
      #resources :shoppinglist_items, only: [:destroy, :create], path: "shoppinglist_items"
    end 
    
    get "debts/:id/resources", to: 'debts#resources', as: 'debt_resources'
    get "debts/page/:page", to: 'debts#index'
  #end

  scope module: "timeline" do 
    post "timeline/events", to: 'events#create', as: 'timeline_events'
  end

  # nicer REST URL structure for paging
  get "agencies/page/:page", to: 'agencies#index'
  get "creditors/page/:page", to: 'creditors#index'
  get "assets/page/:page", to: 'assets#index'

  # country/state lookup data
  get "countries", to: 'countries#index'
  get "countries/:id/states", to: 'countries#states'
  
  # for QA purposes
  if Rails.env == "development"
    get "tests", to: 'tests#index'
  end
end
