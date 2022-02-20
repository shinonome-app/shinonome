# frozen_string_literal: true

Rails.application.routes.draw do
  get 'top/index'
  root to: 'top#index'

  resources :receipts, only: %i[new create]
  namespace :receipts do
    resources :previews, only: %i[create]
    resources :thanks, only: %i[index]
  end

  resources :proofreads, only: %i[index new create]
  namespace :proofreads do
    resources :people, only: %i[index show]
    resources :previews, only: %i[create]
    resources :thanks, only: %i[index]
  end

  resources :idlists, only: %i[index]
  namespace :idlists do
    resources :workers, only: %i[index]
    resources :people, only: %i[index]
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  namespace :admin, path: (ENV['RAILS_ADMIN_PATH'] || 'admin') do
    get '/' => 'top#index'

    devise_for :users, path: 'user', class_name: 'Shinonome::User', controllers: {
      passwords: 'admin/passwords',
      registrations: 'admin/registrations',
      sessions: 'admin/sessions'
    }

    namespace :users do
      resources :others, only: %i[index create edit update destroy]
    end

    resources :news
    resources :people

    namespace :works do
      resources :text_searches, only: %i[index]
      resources :work_index_searches, only: %i[index]
      resources :creator_index_searches, only: %i[index]
      resources :status_searches, only: %i[index]
      resources :unknown_creator_searches, only: %i[index]
    end

    resources :works do
      resources :workfiles
      resources :sites
      resources :original_books, only: %i[new edit create update destroy]
      resources :workers
      resources :bibclasses

      # resources :worker_assigns, only: %i[index new show]
      get 'worker_assigns', to: 'works/worker_assigns#index', as: :worker_assigns
      get 'worker_assigns/new', to: 'works/worker_assigns#new', as: :new_worker_assign
    end

    resources :sites
    resources :workers
    resources :exec_commands, only: %i[index new create]

    resources :receipts

    resources :base_people

    resources :work_workers, only: %i[create destroy], as: :workworkers

    # resources :work_sites
    # resources :person_sites
    # resources :work_people

    # resources :kana_types
    # resources :charsets
    # resources :file_encodings
    # resources :filetypes
    # resources :compresstypes
    # resources :roles
    # resources :worker_roles
  end
end
