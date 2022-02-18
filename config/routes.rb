Rails.application.routes.draw do

  root "home#index"
  resources :kangxis, only: [:index]
  resources :transforms, only: [:index, :create]

  scope path: "wuge", as: "wuge" do
    get "calc", to: "wuge#calc_show"
    post "calc", to: "wuge#calc"
  end

  get "makename", to: "makename#index"
  post "makename", to: "makename#make"

end
