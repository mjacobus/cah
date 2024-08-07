Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { registrations: 'registrations' }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root 'home#index'

  get :export, to: 'addresses#export'

  resources :addresses do
    collection do
      get :search
    end
  end

  resources :circuits do
    resources :congregations do
      resources :addresses do
        get :export, on: :collection
      end
    end
  end
end
