class BooksController < ApplicationController
  deserializable_resource :book, only: %i[create update]

  def index
    render jsonapi: Book.all
  end

  def show
    render jsonapi: Book.find(params[:id])
  end

  def create
    book = Book.new(params[:book])
    if Book.save(book)
      render jsonapi: book, status: :created
    else
      render jsonapi_errors: book.errors
    end
  end

  def update
    book = Book.find(params[:id])
    if book.update(params[:book])
      head :no_content
    else
      render jsonapi_errors: book.errors
    end
  end

  def destroy
    Book.delete(params[:id])

    head :no_content
  end

  def jsonapi_include
    params[:include] || 'series'
  end
end
