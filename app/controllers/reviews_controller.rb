# Controller for reviews
class ReviewsController < ApplicationController
  include Pagy::Backend
  before_action :set_review, only: %i[show edit destroy update]
  before_action :set_book
  
 

  def index
    @pagy, @reviews = pagy(@book.reviews, items: 5)
    respond_to do |format|
			format.json do
        reviews = @book.reviews.all.order("created_at DESC")
        render(json: reviews, status: :ok)
      end			
		end
  end

  def new
    @review = Review.new
  end

  def edit; end

  def create

    auth_token = request.headers["X-User-Token"]    
    @review = @book.reviews.new(review_params)
  
    if(@review.user.authentication_token == auth_token)   
    @review.save
    render json: @review.as_json(), status: :ok 
    else
      render json: { error: true, message: "Cant verify csrf token."}, 
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
    if @review.update(review_params)
      redirect_to @book, notice: 'Review was successfully updated.'
    else
      render :edit
    end
  end

  def destroy

    auth_token = request.headers["X-User-Token"] 
    if(@review.user.authentication_token == auth_token || User.find(1).authentication_token == auth_token)   
    @review.destroy
    render json: @review.as_json(), status: :ok 
  else
    render json: { error: true, message: "Cant verify csrf token."}, 
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
    params.require(:review).permit(:rating, :comment,:user_id)
  end
  
end