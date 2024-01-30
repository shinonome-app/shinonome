# frozen_string_literal: true

Rails.application.routes.draw do
  get 'top/index'
  root to: 'top#index'

  # health check
  get 'up' => 'health#show'

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

  devise_for :admin_users, path: ENV.fetch('RAILS_ADMIN_PATH', nil) || 'admin', class_name: 'Shinonome::User', controllers: {
    passwords: 'admin/passwords',
    registrations: 'admin/registrations',
    sessions: 'admin/sessions'
  }

  namespace :admin, path: ENV.fetch('RAILS_ADMIN_PATH', nil) || 'admin' do
    get '/' => 'top#index'

    namespace :users do
      resources :others, only: %i[index create edit update destroy]
    end

    resources :news_entries

    namespace :people do
      resources :text_searches, only: %i[index]
      resources :person_index_searches, only: %i[index]
    end
    resources :people do
      resources :base_people, only: %i[new create destroy]
      namespace :base_people do
        resources :text_searches, only: %i[index]
      end

      resources :person_sites, only: %i[new create destroy]
      namespace :person_sites do
        resources :text_searches, only: %i[index]
      end
    end

    namespace :works do
      resources :text_searches, only: %i[index]
      resources :work_index_searches, only: %i[index]
      resources :creator_index_searches, only: %i[index]
      resources :status_searches, only: %i[index]
      resources :unknown_creator_searches, only: %i[index]
      resources :previews, only: %i[show]
    end

    resources :works do
      resources :workfiles, only: %i[new edit create update destroy]
      resources :sites
      resources :original_books, only: %i[new edit create update destroy]
      resources :bibclasses

      resources :work_workers, only: %i[new create destroy]
      namespace :work_workers do
        resources :text_searches, only: %i[index]
        resources :worker_index_searches, only: %i[index]
      end

      resources :work_people, only: %i[new create destroy]
      namespace :work_people do
        resources :text_searches, only: %i[index]
      end

      resources :work_sites, only: %i[new create destroy]
      namespace :work_sites do
        resources :text_searches, only: %i[index]
      end
    end

    namespace :sites do
      resources :text_searches, only: %i[index]
    end
    resources :sites

    namespace :workers do
      resources :text_searches, only: %i[index]
      resources :worker_index_searches, only: %i[index]
    end
    resources :workers

    resources :admin_mail_secrets, only: %i[new create]
    namespace :admin_mail_secrets do
      resources :previews, only: %i[create]
    end

    resources :exec_commands, only: %i[index new create]

    resources :typesettings, only: %i[index show new create]

    resources :receipts, only: %i[index show edit update]
    namespace :receipts do
      resources :previews, only: %i[update]
      resources :bulk_removes, only: %i[create]
    end

    resources :proofreads, only: %i[index show edit update destroy] do
      member do
        get '/orders/new', to: 'proofreads/orders#new'
        post '/orders', to: 'proofreads/orders#create'
      end
    end
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

  ## for previews
  resources :index_pages, only: [] do
    collection do
      get 'index_top'
      get 'index_all'

      ## People
      get 'person_:id', to: 'people#index', constraints: { id: /[kstnhmyrw]?a|zz/ }, as: :people
      get 'person:id', to: 'people#show', constraints: { id: /\d+/ }, as: :person

      get 'person_all_:id', to: 'index_pages#person_all_index', constraints: { id: /[kstnhmyrw]?a|zz/ }

      get 'person_inp_:id', to: 'index_pages#person_inp_index', constraints: { id: /[kstnhmyrw]?a|zz/ }

      get 'person_all', to: 'index_pages#person_all'

      get 'list_inp:id_page', to: 'index_pages#list_inp_show', constraints: { id_page: /\d+_\d+/ }, as: :list_inp

      get 'sakuhin_:id_page', to: 'index_pages#work_index', constraints: { id_page: /([kstnhmyrw]?[aiueo]|zz|nn)\d+/ }, as: :sakuhin

      get 'sakuhin_inp_:id_page', to: 'index_pages#work_inp_index', constraints: { id_page: /([kstnhmyrw]?[aiueo]|zz|nn)\d+/ }, as: :sakuhin_inp

      # Whatsnew
      get 'whatsnew:page', to: 'whatsnews#index', constraints: { page: /\d+/ }, as: :whatsnew
      get 'whatsnew_:year_page', to: 'whatsnews#index_year', constraints: { year_page: /\d\d\d\d_\d+/ }, as: :whatsnew_year

      # Download zip files
      get 'list_person_all', to: 'downloads#list_person_all', constraints: { format: 'zip' }
      get 'list_person_all_extended', to: 'downloads#list_person_all_extended', constraints: { format: 'zip' }
      get 'list_person_all_utf8', to: 'downloads#list_person_all_utf8', constraints: { format: 'zip' }
      get 'list_person_all_extended_utf8', to: 'downloads#list_person_all_extended_utf8', constraints: { format: 'zip' }
    end
  end

  mount LetterOpenerWeb::Engine, at: '/letter_opener'
end
