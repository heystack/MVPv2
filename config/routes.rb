Mvpv2::Application.routes.draw do

  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"
  
  resources :users
  resources :users do
    resources :responses
    resources :comments
    resources :votes
  end
  match 'users/:id' => 'users#toggle_admin'
  
  resources :stacks
  resources :stacks do
    resources :responses
    resources :comments
  end
  resources :comments do
    resources :replies
    resources :votes
  end
  resources :communities do
    resources :stacks
  end
  resources :communities
  resources :user_communities

  match '/create_stack', :to => 'stacks#create_stack'
  match '/new_reply',    :to => 'replies#new'
  match '/new_vote',    :to => 'votes#new'

  resources :responses
  resources :comments, :only => [:new, :create, :destroy]
  resources :replies,  :only => [:new, :create, :destroy]
  resources :sessions, :only => [:new, :create, :destroy]
  resources :votes,  :only => [:new, :create, :destroy]

  match '/response',     :to => 'responses#new'
  match '/stkresponses', :to => 'responses#stkresponses'
  match '/stkcomments',  :to => 'comments#stkcomments'

  match '/signup',  :to => 'users#signup'
  match '/show_ghosts',   :to => 'users#show_ghosts'
  match '/delete_ghosts', :to => 'users#delete_ghosts'
  match '/signin',  :to => 'sessions#create'
  match '/signout', :to => 'sessions#destroy'

  match '/toggle_admin', :to => 'users#toggle_admin'
  match '/filter_qualifier', :to => 'stacks#filter_qualifier'

  get "mvp/home"
  get "mvp/contact"
  # 2-factor auth for setting admin: obscure URL plus PIN
  get "mvp/f69b29082d4aabb4"
  
  match '/share',               :to => 'mvp#share_form'
  match '/share_via_email',     :to => 'mvp#share_via_email'
  match '/send_feedback',       :to => 'mvp#send_feedback'
  match '/send_comment',        :to => 'mvp#send_comment'
  match '/stack_request',       :to => 'mvp#stack_request'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "sessions#create"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
