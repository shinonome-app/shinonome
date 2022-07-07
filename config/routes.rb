# frozen_string_literal: true

Rails.application.routes.draw do
  get 'top/index'
  root to: 'top#index'

  resources :receipts, only: %i[new create index] do
    collection do
      post 'new_add_work', to: 'receipts#new_add_work'
      post 'new_remove_work', to: 'receipts#new_remove_work'
    end
  end

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

  namespace :admin, path: (ENV.fetch('RAILS_ADMIN_PATH', nil) || 'admin') do
    get '/' => 'top#index'

    devise_for :users, path: 'user', class_name: 'Shinonome::User', controllers: {
      passwords: 'admin/passwords',
      registrations: 'admin/registrations',
      sessions: 'admin/sessions'
    }

    namespace :users do
      resources :others, only: %i[index create edit update destroy]
    end

    resources :news_entries

    namespace :people do
      resources :text_searches, only: %i[index]
    end
    resources :people do
      resources :base_people, only: %i[new create edit update destroy]
      namespace :base_people do
        resources :text_searches, only: %i[index]
        resources :binds, only: %i[create]
      end

      resources :person_sites, only: %i[new create edit update destroy]
      namespace :person_sites do
        resources :text_searches, only: %i[index]
        resources :binds, only: %i[create]
      end
    end

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
      resources :bibclasses

      resources :work_workers, only: %i[new edit create update destroy]
      namespace :work_workers do
        resources :text_searches, only: %i[index]
        resources :binds, only: %i[create]
      end

      resources :work_people, only: %i[new create edit update destroy]
      namespace :work_people do
        resources :text_searches, only: %i[index]
        resources :binds, only: %i[create]
      end

      resources :work_sites, only: %i[new create edit update destroy]
      namespace :work_sites do
        resources :text_searches, only: %i[index]
        resources :binds, only: %i[create]
      end

      # resources :worker_assigns, only: %i[index new show]
      get 'worker_assigns', to: 'works/worker_assigns#index', as: :worker_assigns
      get 'worker_assigns/new', to: 'works/worker_assigns#new', as: :new_worker_assign
    end

    namespace :sites do
      resources :text_searches, only: %i[index]
    end
    resources :sites

    namespace :workers do
      resources :text_searches, only: %i[index]
    end
    resources :workers

    resources :admin_mail_secrets, only: %i[new create]
    namespace :admin_mail_secrets do
      resources :previews, only: %i[create]
    end

    resources :exec_commands, only: %i[index new create]

    resources :receipts, only: %i[index edit update]
    namespace :receipts do
      resources :previews, only: %i[update]
      resources :bulk_removes, only: %i[create]
    end

    resources :proofreads, only: %i[index edit update]
    namespace :proofreads do
      resources :previews, only: %i[update]
      resources :bulk_removes, only: %i[create]
    end

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

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
