# frozen_string_literal: true

Rails.application.routes.draw do
  get 'top/index'
  root to: 'top#index'

  resources :workers, only: %i[index show]

  resources :receipts, only: %i[new create]
  namespace :receipts do
    resources :previews, only: %i[create]
    resources :thanks, only: %(index)
  end

  resources :proofreads

  resources :idlists, only: %i[index]
  namespace :idlists do
    resources :workers, only: %i[index]
    resources :people, only: %i[index]
  end

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
    namespace :books do
      resources :text_searches, only: %i[index]
      resources :book_index_searches, only: %i[index]
      resources :creator_index_searches, only: %i[index]
      resources :status_searches, only: %i[index]
      resources :unknown_creator_searches, only: %i[index]
    end
    resources :books do
      resources :bookfiles
      resources :sites
      resources :original_books
      resources :workers
      resources :bibclasses
    end
    resources :bookfiles
    resources :sites
    resources :original_books
    resources :workers

    resources :receipts

    resources :base_people

    # resources :book_sites
    # resources :book_workers
    # resources :person_sites
    # resources :book_people

    # resources :kana_types
    # resources :charsets
    # resources :file_encodings
    # resources :filetypes
    # resources :compresstypes
    # resources :roles
    # resources :worker_roles
  end
end
