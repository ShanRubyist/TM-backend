Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "users/sessions#new"
  #

  require 'sidekiq/web'
  # authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  # end

  namespace :api do
    namespace :v1 do
      # match "*path", to: "api#gone", via: :all
      resources :websites do
        member do
          get 'screenshots' => 'websites#screenshots', as: 'screenshots'
        end
      end
    end
  end
end
