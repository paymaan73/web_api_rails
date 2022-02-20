class BookPresenter < BasePresenter
  build_with :id, :title, :subtitle, :isbn_10, :isbn_13, :description,
             :released_on, :publisher_id, :author_id, :created_at,
             :updated_at, :cover


  def cover
    @object.cover.url.to_s
  end
end
