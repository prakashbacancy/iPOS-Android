Rails.application.routes.draw do
  devise_for :users, controllers: { passwords: 'passwords', sessions: 'sessions' }

  root to: 'homes#dashboard'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :admin do
    resources :users
  end
end
