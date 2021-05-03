# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :receipts do
    get 'thanks' => '/receipts/thanks#index'
  end
  get 'idlist/index'
  get 'top/index'
  root to: 'top#index'

  resources :book_sites
  resources :original_books
  resources :book_workers
  resources :workers, only: %i[index show]
  resources :receipts, only: %i[new create] do
    resources :previews, only: %i[create]
  end
  resources :proofreads
  resources :person_sites
  resources :bookfiles
  resources :book_people
  resources :base_people

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  namespace :admin do
    get '/' => 'top#index'

    devise_for :users, controllers: {
      passwords: 'admin/passwords',
      registrations: 'admin/registrations',
      sessions: 'admin/sessions'
    }

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
