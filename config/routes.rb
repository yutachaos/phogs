Rails.application.routes.draw do
  root 'searches#index'
  post 'result',   to: 'searches#result'
end
