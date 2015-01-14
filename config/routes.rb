Rails.application.routes.draw do
  mount Upmin::Engine => '/admin'
  root to: 'home#index'
  devise_for :users
end
