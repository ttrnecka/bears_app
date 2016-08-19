Rails.application.routes.draw do
  
  root 'static_pages#home'
  
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/about', to: 'static_pages#about'
  get '/help', to: 'static_pages#help'
  get '/contact', to: 'static_pages#contact'
  get '/news', to: 'static_pages#news'
  
  resources :users
end
