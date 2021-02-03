Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :members, only: %i[index show]
      resources :constituency do
        resources :addresses
      end
      resources :expenditures, only: %i[show index]

      get 'search/member', to: 'searches#member'
      get 'search/constituency', to: 'searches#constituency'
    end
  end
end
