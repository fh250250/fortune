Rails.application.routes.draw do

  root "home#index"
  resources :kangxis, only: [:index]

  get "convert", to: "convert#index"
  post "convert", to: "convert#convert"

end
