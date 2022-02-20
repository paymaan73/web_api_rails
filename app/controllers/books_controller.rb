class BooksController < ApplicationController

  def index
    books = Book.all.map do |book|
      FieldPicker.new(BookPresenter.new(book, params)).pick
    end

    render json: { data: books }.to_json
  end

end
