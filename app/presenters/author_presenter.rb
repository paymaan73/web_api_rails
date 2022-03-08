class AuthorPresenter < BasePresenter
  related_to :books
  sort_by :id, :given_name, :family_name, :created_at, :updated_at
  filter_by :id, :given_name, :family_name, :created_at, :updated_at
  build_with :id, :given_name, :family_name, :created_at, :updated_at
end
