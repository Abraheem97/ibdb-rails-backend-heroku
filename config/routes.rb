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
  get 'books/:startIndex/:numOfBooks', controller: 'books', action: 'getBooks'
  get 'comments/:book_id/:startIndex/:numOfComments', controller: 'comments', action: 'getComments'
  get 'replies/:comment_id', controller: 'comments', action: 'getReplies'
  get 'searchBooks/:search', controller: 'books', action: 'getBooksBySearch'


  namespace :v1 do
    resources :authors, only: %i[create]
    resources :sessions, only: %i[create destroy]
    get '/author/:id', controller: 'authors', action:'getAuthor'
    get '/:id/user', controller: 'users', action: 'index'
    get '/:id/user_details', controller: 'users', action: 'getUser'
    get '/:user_id/:book_id/bookreviewed', controller: 'users', action: 'hasReviewedBook'
    get '/author/:id/books', controller: 'authors', action: 'getBooks'
    get '/authors', controller: 'authors', action: 'getAuthors'
    patch '/update_user/:user_id', controller: 'users', action: 'update'
    post '/verifyAccount', controller: 'users', action: 'verifyAccount'
    
  end
  mount ActionCable.server => '/cable'
end
