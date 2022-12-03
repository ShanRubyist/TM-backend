Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "users/sessions#new"
  #


  namespace :api, path: nil do
    namespace :v1 do
      # match "*path", to: "api#gone", via: :all
    end
  end
end
