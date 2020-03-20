# Controller for comments
class CommentsController < ApplicationController
  before_action :set_comment, only: %i[show edit destroy update]
  before_action :set_book
  
  def index 
    respond_to do |format|
			format.json do
        comments = @book.comments.all.order("created_at DESC")
        render(json: comments, status: :ok)
      end			
		end
  end

  def new
    @comment = Comment.new
  end

  def edit; end

  def create
    auth_token = request.headers["X-User-Token"]    
    @comment = @book.comments.new(comment_params)
  
    if(@comment.user.authentication_token == auth_token)   
    @comment.save
    render json: @comment.as_json(), status: :ok 
    else
      render json: { error: true, message: "Cant verify csrf token."}, 
      status: 401
      head(:unauthorized)
    end
        
         
    
    #  unless @comment.parent_id.nil?
    #    @reply = @comment
    #  end
 
  end

  def update
    if @comment.update(comment_params)
      redirect_to @book, notice: 'Comment was successfully updated.'
    else
      render :edit
    end
  end

  def destroy

    auth_token = request.headers["X-User-Token"] 
    if(@comment.user.authentication_token == auth_token || User.find(1).authentication_token == auth_token)
    @comment.destroy
    render json: @comment.as_json(), status: :ok 
  else
    render json: { error: true, message: "Cant verify csrf token."}, 
    status: 401
    head(:unauthorized)
  end
    # @comment.destroy
    # respond_to do |format|
    #   format.js { @comment }
    # end
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :parent_id, :image, :user_id)
  end

  def set_book
    @book = Book.find(params[:book_id])
  end

end