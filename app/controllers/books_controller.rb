class BooksController < ApplicationController

  def show
    # @book = Book.find(params[:id])
  
    #追記
    @book = Book.find(params[:id])
    @book_new = Book.new
    @post_comment = PostComment.new
    @user = @book.user
    @book_detail = Book.find(params[:id])
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book_detail.id)
      current_user.view_counts.create(book_id: @book_detail.id)
    end
  end

  def index
    # @books = Book.all
    # @book = Book.new
    # to  = Time.current.at_end_of_day
    # from  = (to - 6.day).at_beginning_of_day
    # @books = Book.all.sort {|a,b| 
    #   b.favorites.where(created_at: from...to).size <=> 
    #   a.favorites.where(created_at: from...to).size
    # }
    @book = Book.new
    
    if params[:latest]
     @books = Book.latest
    # elsif params[:old]
    # @books = Book.old
    elsif params[:star_count]
     @books = Book.star_count
    else
     @books = Book.all
    end
 
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book.id), notice: "You have created book successfully."
    else
      @books = Book.all
      render "index"
    end
  end

  def edit
    @book = Book.find(params[:id])
    @user = @book.user
    unless @user.id == current_user.id
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private
  
  def book_params
    params.require(:book).permit(:title, :body, :profile_image, :star, :category)#ここのstar
  end
  
end
