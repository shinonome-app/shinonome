Rails.application.routes.draw do

  get 'top/index'
  root to: 'top#index'

  resources :worker_roles
  resources :roles
  resources :kana_types
  resources :charsets
  resources :file_encodings
  resources :sites
  resources :book_sites
  resources :original_books
  resources :book_workers
  resources :compresstypes
  resources :bibclasses
  resources :filetypes
  resources :workers
  resources :receipts
  resources :proofreads
  resources :person_sites
  resources :bookfiles
  resources :book_people
  resources :books
  resources :base_people
  resources :news
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :admin do
    get '/' => 'top#index'

    resources :people
  end
end
