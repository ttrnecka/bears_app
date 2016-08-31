Rails.application.routes.draw do
  
  mount MagicLamp::Genie, at: "/magic_lamp" if defined?(MagicLamp)
  
  get 'sessions/new'

  root 'static_pages#home'
  
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/about', to: 'static_pages#about'
  get '/help', to: 'static_pages#help'
  get '/news', to: 'static_pages#news'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users
  resources :storage_arrays, only: [:index]
end