class V1::UsersController< ApplicationController

  def index
    respond_to do |format|
    format.json do 
       
      user = User.find(params[:id])    
      render json: user, only: [:email], status: :ok
    end 
  end
end

def hasReviewedBook
  respond_to do |format|
    format.json do 
       
      user = User.find(params[:user_id]) 
      if user.reviews.exists?(book_id: params[:book_id])   
      render json: {  "hasReviewed": true }
      else 
        render json: {  "hasReviewed": false }
      end 
    end 
  end
end
end
