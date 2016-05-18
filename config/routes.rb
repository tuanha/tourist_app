Rails.application.routes.draw do
  devise_for :tourguides
  devise_for :travellers
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'devices#index'

  resources :users
  resources :devices
  resources :feedbacks

  resources :tours do
    collection do
      post 'select_tourguide'
      post 'cancel_tourguide'
      post 'action_traveller'
      post 'remove_device'
      post 'set_device'
    end
  end

  resources :tourguides do
    collection do
      post 'create'
      patch 'update'
      get 'index', as: :index
    end
  end

  resources :travellers do
    collection do
      post 'create'
      patch 'update'
      get 'index', as: :index
    end
  end

  namespace :api do
    get "devices" => "devices#show"
    post "devices" => "devices#create"
    post "devices/update_position" => "devices#update_position"
    get "tours/list_users" => "tours#users_list"
    post "tours/feedbacks" => "tours#feedbacks"
    get "tours" => "tours#show"
    post 'tours/join' => "tours#join"
  end

  post 'api/authenticate_user' => "authentication#authenticate_user"

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
