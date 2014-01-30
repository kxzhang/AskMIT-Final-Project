Ask::Application.routes.draw do


  get "notifications/index"

  root to: 'static_pages#home'
 
  match '/about' =>  'static_pages#about', :as => :about
  match '/contact' => 'static_pages#contact', :as => :contact

  match '/cloud/' => 'hashtags#wordcloud', :as => :cloud
  match '/hashtags/:name/view' => 'hashtags#view'

  resources :users
  match '/login' => 'sessions#new', :as => :login
  match '/logout' => 'sessions#destroy', :as => :logout
  match '/sessions' => 'sessions#create', :as => :sessions
  match '/confirm' => 'users#confirm', :as => :confirm



  scope "/main" do
    resources :questions do
      resources :answers
    end
   
   # for AJAX POST requests, since not all browsers support PUT, DELETE
   match '/questions/:id/update' => 'questions#update', :as => 'update_question', :via => 'POST'
   match '/questions/:id/delete' => 'questions#destroy', :as => 'delete_question', :via => 'POST'
   match '/answers/:id/update' => 'answers#update', :as => 'update_answer', :via => 'POST'
   match '/answers/:id/delete' => 'answers#destroy', :as => 'delete_answer', :via => 'POST'

   match '/questions/request_send_email' => 'questions#request_send_email', :as => 'request_answer', :via => 'POST'
  
   match '/upvote' => 'votes#upvote', :as => 'upvote'
   match '/downvote' => 'votes#downvote', :as => 'downvote'

   match '/follow/toggle' => 'follows#toggle'

   # probably should simplify the following
   match '/' => 'main#index', :as => 'main'
   match '/question_titles' => 'main#question_titles', :as => 'question_titles' # maybe move to question controller later
   match '/hashtag_names' => 'main#hashtag_names', :as => 'hashtag_names'
   match '/recent' => 'main#recent', :as => 'recent'
   match '/search' => 'main#search', :as => 'search'
   match '/sort' => 'main#sort', :as => 'sort'
   match '/notifications' => 'notifications#index', :as => 'notifications'
   match '/new_notifications' => 'notifications#new_notifications', :as => 'new_notifications'
   match '/mark_read' => 'notifications#mark_read', :as => 'mark_read'

   # TODO: include name of hashtag in the URL?
   scope '/hashtags' do
    match '/:id' => 'hashtags#show', :as => 'hashtag'
    match '/:id/sort' => 'hashtags#sort', :as => 'sort'
   end
  end


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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
