Rails.application.routes.draw do
  root 'searches#index'
  resources 'searches' do
    collection do 
      get 'get_location'
    end
  end
  #get "searches#get_location"
  post 'result', to: 'finds#result'
  get 'result', to: 'finds#result'
end
