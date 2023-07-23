Rails.application.routes.draw do
  root to: 'rooms#index'

  resource :session, only: %i[new create destroy]

  resources :users

  resources :rooms, only: %i[index show create destroy]

  mount ActionCable.server => "/cable"
end
