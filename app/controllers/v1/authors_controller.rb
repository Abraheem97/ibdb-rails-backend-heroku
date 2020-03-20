class V1::AuthorsController< ApplicationController
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
end
