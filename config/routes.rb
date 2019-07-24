Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: 'registrations', passwords: 'passwords'}
  root 'grams#index'
  resources :grams do
    resources :comments, only: :create
  end
end
