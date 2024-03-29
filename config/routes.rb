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

  # 跨域预检请求
  match '*all', controller: 'application', action: 'cors_preflight_check', via: [:options]

  namespace :api do
    namespace :v1 do
      # match "*path", to: "api#gone", via: :all
      resources :websites do
        member do
          get 'screenshots' => 'websites#screenshots', as: 'screenshots'
        end
      end

      get 'info' => 'info#info', as: 'info'

      get 'before_direct_upload' => 'direct_upload_management#before_direct_upload'
      post 'upload_callback' => 'direct_upload_management#upload_callback'
    end
  end
end
