Rails.application.routes.draw do
  require 'sidekiq/web'

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users
  apipie

  root "page#index"
  resources :feeds, only: %i[index]

  resources :articles, only: %i[index show]

  resources :stories, only: %i[index show] do
    member do
      get 'approve'
      get 'disapprove'
    end
  end

  resources :discussions, only: %i[index show]

  resources :tweets, only: %i[index edit show update] do
    member do
      get 'approve'
      get 'disapprove'
    end
  end

  resources :instapins, only: %i[index edit show update] do
    member do
      get 'approve'
      get 'disapprove'
    end
  end

  resources :imaginations, only: %i[index]
  resources :tags, only: %i[index]
  resources :pillars, only: %i[index]

  resources :unauthorized, only: %i[index]

  resources :settings, only: [:index, :edit]
  resource :settings, only: [:update]

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      resource :test, only: %i[index]
    end
  end

  namespace :webhooks do
    resources :midjourney
  end
end
