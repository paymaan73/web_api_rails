class BooksController < ApplicationController

  def index
    render json: { data: Book.all }
  end

end
