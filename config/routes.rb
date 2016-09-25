# == Route Map
#
#                   Prefix Verb   URI Pattern                            Controller#Action
#                 teaspoon        /teaspoon                              Teaspoon::Engine
# search_admin_credentials GET    /admin/credentials/search(.:format)    admin/credentials#search
#        admin_credentials GET    /admin/credentials(.:format)           admin/credentials#index
#                          POST   /admin/credentials(.:format)           admin/credentials#create
#     new_admin_credential GET    /admin/credentials/new(.:format)       admin/credentials#new
#    edit_admin_credential GET    /admin/credentials/:id/edit(.:format)  admin/credentials#edit
#         admin_credential GET    /admin/credentials/:id(.:format)       admin/credentials#show
#                          PATCH  /admin/credentials/:id(.:format)       admin/credentials#update
#                          PUT    /admin/credentials/:id(.:format)       admin/credentials#update
#                          DELETE /admin/credentials/:id(.:format)       admin/credentials#destroy
#               magic_lamp        /magic_lamp                            MagicLamp::Engine
#             sessions_new GET    /sessions/new(.:format)                sessions#new
#                     root GET    /                                      static_pages#home
#                   signup GET    /signup(.:format)                      users#new
#                          POST   /signup(.:format)                      users#create
#                    about GET    /about(.:format)                       static_pages#about
#                     help GET    /help(.:format)                        static_pages#help
#                     news GET    /news(.:format)                        static_pages#news
#                    login GET    /login(.:format)                       sessions#new
#                          POST   /login(.:format)                       sessions#create
#                   logout DELETE /logout(.:format)                      sessions#destroy
#                    users GET    /users(.:format)                       users#index
#                          POST   /users(.:format)                       users#create
#                 new_user GET    /users/new(.:format)                   users#new
#                edit_user GET    /users/:id/edit(.:format)              users#edit
#                     user GET    /users/:id(.:format)                   users#show
#                          PATCH  /users/:id(.:format)                   users#update
#                          PUT    /users/:id(.:format)                   users#update
#                          DELETE /users/:id(.:format)                   users#destroy
#  resource_storage_arrays GET    /resource/storage/arrays(.:format)     resource/storage/arrays#index
#   resource_storage_array GET    /resource/storage/arrays/:id(.:format) resource/storage/arrays#show
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
  
  namespace :admin do
    resources :credentials do
      collection do
        get "search"
      end
    end
    resources :resources
  end
  
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
