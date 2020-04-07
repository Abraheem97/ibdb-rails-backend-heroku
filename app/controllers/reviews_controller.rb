# Controller for reviews
class ReviewsController < ApplicationController
  include Pagy::Backend
  before_action :set_review, only: %i[show edit destroy update]
  before_action :set_book

  def index
    @pagy, @reviews = pagy(@book.reviews, items: 5)
    respond_to do |format|
      format.json do
        reviews = @book.reviews.all.order('created_at DESC')
        render(json: reviews, status: :ok)
      end
    end
  end

  def new
    @review = Review.new
  end

  def edit; end

  def create
    auth_token = request.headers['X-User-Token']
    @review = @book.reviews.new(review_params)

    if @review.user.authentication_token == auth_token
      @review.save
      render json: @review.as_json, status: :ok
    else
      render json: { error: true, message: 'Cant verify csrf token.' },
             status: 401
      head(:unauthorized)
    end
    # @review = Review.new(review_params)
    # @review.user = current_user
    # @review.book = @book
    # if @review.save
    #   redirect_to @book, notice: 'Review was successfully created.'
    # else
    #   render :new
    # end
  end

  def update
    auth_token = request.headers['X-User-Token']

    if @review.user.authentication_token == auth_token
      @review.update(review_params)
      render json: @review.as_json, status: :ok
    else
      render json: { error: true, message: 'Cant verify csrf token.' },
             status: 401
      head(:unauthorized)
    end
  end

  def destroy
    auth_token = request.headers['X-User-Token']

    user = User.find(params[:user_id])

    if auth_token === user.authentication_token
      if user.moderator_role || user.admin_role || user.superadmin
        @review.destroy
        render json: @review.as_json, status: :ok
      else
        if @review.user.id === user.id
          @review.destroy
          render json: @review.as_json, status: :ok
      end
    end
    else
      render json: { error: true, message: 'Cant verify csrf token.' },
             status: 401
      head(:unauthorized)

    end
    # @review.destroy
    # redirect_to reviews_url, notice: 'Review was successfully destroyed.'
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def set_book
    @book = Book.find(params[:book_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment, :user_id)
  end
end
