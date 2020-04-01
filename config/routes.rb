Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/sadmin', as: 'rails_admin'
  devise_for :users, controllers: { confirmations: 'confirmations' }

  resources :books do
    resources :reviews, except: [:show]
    resources :comments, except: [:show]
  end

  scope :auth do
    get 'is_signed_in', to: 'auth#is_signed_in?'
  end

  root 'books#index'
  get 'books/:id/author', controller: 'books', action: 'show_author', as: 'show_author'

  namespace :v1 do
    resources :sessions, only: %i[create destroy]
    get '/:id/user', controller: 'users', action: 'index'
    get '/:id/user_details', controller: 'users' , action: 'getUser'
    get '/:user_id/:book_id/bookreviewed', controller: 'users', action: 'hasReviewedBook'
    get '/author/:id/books', controller: 'authors', action: 'getBooks'
    get '/authors', controller: 'authors', action: 'getAuthors'
    patch '/update_user/:user_id', controller: 'users', action: 'update'
  end
  mount ActionCable.server => '/cable'
end
