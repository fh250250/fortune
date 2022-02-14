Rails.application.routes.draw do

  root "home#index"
  resources :kangxis, only: [:index]
  resources :transforms, only: [:index, :create]

end
