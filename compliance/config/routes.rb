Rails.application.routes.draw do
  constraints ->(req) { req.format == :jsonapi } do
    resources :books
    resources :authors
  end
end
