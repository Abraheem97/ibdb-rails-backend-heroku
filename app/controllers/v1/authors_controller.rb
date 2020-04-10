class V1::AuthorsController < ApplicationController
  def getBooks
    books = Book.where(author_id: params[:id])
    respond_to do |format|
      format.json do
        render json: books, status: :ok
      end
    end
  end

  def getAuthors
    authors = Author.pluck(:name)
    respond_to do |format|
      format.json do
        render json: authors, status: :ok
      end
    end
    end
  
  def getAuthor
    author = Author.find_by(id: params[:id])
    respond_to do |format|
      format.json do
        render json: author, status: :ok
      end
    end
    end

    def create
      auth_token = request.headers['X-User-Token']

      user = User.find(params[:user_id])
  
      if user.moderator_role || user.admin_role || user.superadmin
        if auth_token == user.authentication_token
          @author = Author.create(author_params)        
          @author.save
          render json: @author, status: :ok
        end
      end
    end

    def author_params
      params.require(:author).permit(:name,:image_url,:description)
    end
end
