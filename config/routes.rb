Rails.application.routes.draw do
  root 'searches#index'
  # resources 'searches' do
  #   collection do
  #     get 'get_location'
  #   end
  # end
  get  'map',  to: 'searches#map'
  get  'searches/get_location',  to: 'searches#get_location'
  post 'result',   to: 'finds#result'
  get  'show/:id', to: 'finds#show'
end
