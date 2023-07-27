Rails.application.routes.draw do
  root to: 'rooms#index'

  resource :session, only: %i[new create destroy]

  resources :users

  resources :rooms, only: %i[index show create destroy]

  mount ActionCable.server => '/cable'

  get '/private_rooms/:user_id', to: 'rooms#private_room_with_user', as: :private_room_with_user
end
