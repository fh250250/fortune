Rails.application.routes.draw do

  root "home#index"
  resources :kangxis, only: [:index]

end
