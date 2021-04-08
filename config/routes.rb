Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/merchants/find_one', to: 'merchants/search#show'
      resources :merchants, only: [:index, :show]
      resources :items, only: [:index, :show, :create, :update, :destroy]

      namespace :revenue do
        get '/merchants/:id', to: 'merchants#show'
      end
    end
  end
end
