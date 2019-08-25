# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  concern :api_base do
    resources :animals
    get '/random', to: 'animals#random'
    get '/search', to: 'animals#search'
  end

  namespace :v1 do
    concerns :api_base
  end
end
