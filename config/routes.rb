Rails.application.routes.draw do
  mount Upmin::Engine => '/admin'

  root to: 'home#index'

  resources :queries do
    member do
      match 'update_email', via: [:put, :post]
    end
  end

  get 'wechat', to: 'wechat#index'
  get 'wechat/result', to: 'wechat#result', as: :wechat_result
  get 'wechat/auth_return', to: 'wechat#auth_return'
  post 'wechat/notify', to: 'wechat#notify', as: :wechat_notify

  devise_for :users
end
