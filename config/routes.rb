Rails.application.routes.draw do
  get 'events/add' => 'events#add', as: 'add_event'
  get 'events/list' => 'events#list', as: 'list_events'
  get 'event/:id' => 'events#show', as: 'show_event'

  # users
  get 'user/signin' => 'sessions#new'
  post 'user/signin' => 'sessions#create'

  get 'user/logout' => 'sessions#destroy'

  get 'user/signup' => 'users#new'
  post 'user/signup' => 'users#create'

  get '~:user_name'  => 'users#show', as: 'user_profile'
  get 'user/profile/edit' => 'users#profile', as: 'edit_user_profile'
  post 'user/profile/edit' => 'users#profile'

  get 'user/password/new' => 'users#reset_password_new'
  post 'user/password/new' => 'users#reset_password_new', as: 'user_reset_password_new'
  get 'user/password/edit' => 'users#reset_password_change'
  post 'user/password/edit' => 'users#reset_password_change', as: 'user_reset_password_change'

  # events

  # mainly
  root 'home#index'
  get 'about' => 'home#about'
  get 'contact' => 'home#contact'
  get 'terms' => 'home#terms'
  get 'privacy' => 'home#privacy'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
