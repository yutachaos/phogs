Rails.application.routes.draw do
  root 'finds#index'
  resources :finds, only: :index

end
