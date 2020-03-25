# Controller for books
class BooksController < ApplicationController
  include Pagy::Backend
  before_action :find_book, only: %i[show edit destroy update upvote add_author show_author]

  def index
    if params[:search]
      @pagy, @books = pagy(Book.by_both(params[:search]), items: 3)
    else
      @pagy, @books = pagy(Book.all, items: 5)
    end
    respond_to do |format|
      format.json do
        book_json = Book.all
        render(json: book_json, status: :ok)
      end
      format.html
    end
  end

  def show
    @comment = Comment.new
    @pagy, @comments = pagy(@book.comments.where(parent_id: nil).order('created_at DESC'), items: 10)
    @reviews = @book.reviews

    if @reviews.blank?
      @avg_review = 0
      @emptystars = 5
    else
      @avg_review = @reviews.average(:rating).floor
      @emptystars = 5 - @avg_review.to_i
    end
  end

  def new # for moderator only, admin and sadmin will use dashoboard to create
    unless user_signed_in? && current_user.moderator_role == true
      redirect_to root_path
    end
    @book = Book.new
  end

  def create
    auth_token = request.headers['X-User-Token']

    user = User.find(params[:user_id])

    if user.moderator_role || user.admin_role || user.superadmin
      if auth_token == user.authentication_token
        @book = Book.create(book_params)
        @author = Author.find_or_create_by(name: @book.author_name)
        @book.author = @author
        @book.save
        render json: @book.as_json, status: :ok
      end
    end
    # @book = Book.create(book_params)
    # @author = Author.find_or_create_by(name: @book.author_name)
    # @book.author = @author
    # @book.save
    # redirect_to @book, notice: 'Successfully created book'
  end

  def edit; end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: 'book was successfully updated'
    else
      render 'edit'
    end
  end

  def destroy
    auth_token = request.headers['X-User-Token']
    if User.find(1).authentication_token == auth_token
      @book.destroy
      render json: @book.as_json, status: :ok
    else
      render json: { error: true, message: 'Cant verify csrf token.' },
             status: 401
      head(:unauthorized)
    end
    # @book.destroy
    # redirect_to root_path
  end

  def show_author
    @author = @book.author

    respond_to do |format|
      format.json do
        book_json = @author
        render(json: book_json, status: :ok)
      end
      format.html
    end
  end

  def devise_current_user
    respond_to do |format|
      format.json do
        render(json: current_user, status: :ok) if current_user
      end
      format.html
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :author_name, :image, :image_url)
  end

  def find_book
    @book = Book.find(params[:id])
  end
end
