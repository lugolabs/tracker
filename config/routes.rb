Rails.application.routes.draw do
  # Clearance
  resources :passwords, controller: 'clearance/passwords', only: [:create, :new]
  resource :session, controller: 'clearance/sessions', only: [:create]
  resources :users, only: %i[new create] do
    resource :password, controller: 'clearance/passwords', only: [:create, :edit, :update]
  end

  resource :user, only: %i[edit update]

  get '/sign_in' => 'clearance/sessions#new', as: 'sign_in'
  delete '/sign_out' => 'clearance/sessions#destroy', as: 'sign_out'
  get '/sign_up' => 'users#new', as: 'sign_up'

  resources :timer, only: :index
  resources :reports, only: :index
  resources :clients, only: %i[create update destroy]
  resources :projects do
    resources :tasks, only: %i[new edit create update destroy]
  end
  resources :slots, only: %i[edit show create update destroy] do
    post :stop, on: :member
  end
  resources :manual_slots, only: %i[new create]

  root 'timer#index'
end
