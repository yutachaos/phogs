Rails.application.routes.draw do
  root 'searches#index'
  resources 'searches'
  #get "searches#get_location"
  get 'result', to: 'finds#result'
end
