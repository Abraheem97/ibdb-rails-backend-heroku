class V1::UsersController < ApplicationController
  def index
    respond_to do |format|
      format.json do
        user = User.find(params[:id])
        render json: user, only: %i[email image_url], status: :ok
      end
    end
end

def getUser
 
  auth_token = request.headers['X-User-Token']
  user = User.find(params[:id])
  

  respond_to do |format|
    format.json do     
      if user.authentication_token == auth_token
      render json: user, only: %i[email image_url unconfirmed_email] ,status: :ok
      
      else 
        render json: { error: true, message: 'Cant verify csrf token.' },
        status: 401
        head(:unauthorized)
      end
    end
  end
end

def update
  
  auth_token = request.headers['X-User-Token']
    @user = User.find(params[:user_id])
   
  if @user.authentication_token == auth_token && @user.valid_password?(params[:user][:current_password])
    @user.update(user_params)
    render json: @user, only: %i[email image_url unconfirmed_email authentication_token] , status: :ok
  else
    render json: { error: true, message: 'Cant verify csrf token.' },
           status: 402
    head(:unauthorized)
  end

end

  def hasReviewedBook
    respond_to do |format|
      format.json do
        user = User.find(params[:user_id])
        if user.reviews.exists?(book_id: params[:book_id])
          render json: { "hasReviewed": true }
        else
          render json: { "hasReviewed": false }
        end
      end
    end
  end



  def user_params
    params.require(:user).permit(:email, :password, :image_url, :password_confirmation)
  end
end
