# == Route Map
#
#                  Prefix Verb   URI Pattern                        Controller#Action
#                teaspoon        /teaspoon                          Teaspoon::Engine
#              magic_lamp        /magic_lamp                        MagicLamp::Engine
#            sessions_new GET    /sessions/new(.:format)            sessions#new
#                    root GET    /                                  static_pages#home
#                  signup GET    /signup(.:format)                  users#new
#                         POST   /signup(.:format)                  users#create
#                   about GET    /about(.:format)                   static_pages#about
#                    help GET    /help(.:format)                    static_pages#help
#                    news GET    /news(.:format)                    static_pages#news
#                   login GET    /login(.:format)                   sessions#new
#                         POST   /login(.:format)                   sessions#create
#                  logout DELETE /logout(.:format)                  sessions#destroy
#                   users GET    /users(.:format)                   users#index
#                         POST   /users(.:format)                   users#create
#                new_user GET    /users/new(.:format)               users#new
#               edit_user GET    /users/:id/edit(.:format)          users#edit
#                    user GET    /users/:id(.:format)               users#show
#                         PATCH  /users/:id(.:format)               users#update
#                         PUT    /users/:id(.:format)               users#update
#                         DELETE /users/:id(.:format)               users#destroy
# resource_storage_arrays GET    /resource/storage/arrays(.:format) resource/storage/arrays#index
#
# Routes for Teaspoon::Engine:
#    root GET  /                             teaspoon/suite#index
# fixture GET  /fixtures/*filename(.:format) teaspoon/suite#fixtures
#   suite GET  /:suite(.:format)             teaspoon/suite#show {:defaults=>{:suite=>"default"}}
#         POST /:suite/:hook(.:format)       teaspoon/suite#hook {:defaults=>{:suite=>"default", :hook=>"default"}}
#
# Routes for MagicLamp::Engine:
#   root GET  /                magic_lamp/fixtures#index
#   lint GET  /lint(.:format)  magic_lamp/lint#index
#        GET  /*name(.:format) magic_lamp/fixtures#show
#

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
  namespace :resource do
    namespace :storage do
      resources :arrays, only: [:index, :show]
    end
  end
end
