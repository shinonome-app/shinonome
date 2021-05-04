# frozen_string_literal: true

Rails.application.routes.draw do
  get 'top/index'
  root to: 'top#index'

  resources :book_sites
  resources :original_books
  resources :book_workers
  resources :workers, only: %i[index show]
  resources :receipts, only: %i[new create]
  namespace :receipts do
    resources :previews, only: %i[create]
    resources :thanks, only: %(index)
  end
  resources :proofreads
  resources :person_sites
  resources :bookfiles
  resources :book_people
  resources :base_people

  namespace :idlists do
    resources :workers, only: %i[index]
    resources :people, only: %i[index]
  end
  resources :idlists, only: %i[index]

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  namespace :admin do
    get '/' => 'top#index'

    devise_for :users, controllers: {
      passwords: 'admin/passwords',
      registrations: 'admin/registrations',
      sessions: 'admin/sessions'
    }

    namespace :users do
      resources :others, only: %i[index create edit update destroy]
    end

    resources :news
    resources :people
    resources :sites
    resources :workers
    resources :books
    # resources :kana_types
    # resources :charsets
    # resources :file_encodings
    # resources :filetypes
    # resources :compresstypes
    # resources :roles
    # resources :worker_roles
  end
end
