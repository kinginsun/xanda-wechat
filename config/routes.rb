Rails.application.routes.draw do
  mount Upmin::Engine => '/admin'

  root to: 'home#index'

  get 'wechat', to: 'wechat#index'
  get 'wechat/auth_return', to: 'wechat#auth_return'
  post 'wechat/notify', to: 'wechat#notify', as: :wechat_notify

  devise_for :users
end
