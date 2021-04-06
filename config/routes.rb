Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get '/merchants/find_one', to: 'merchants/search#show'
      resources :merchants, only: [:index, :show]
    end
  end
end
