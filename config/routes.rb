Rails.application.routes.draw do
  scope :api do
    resources :books
  end
end
