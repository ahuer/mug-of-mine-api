Rails.application.routes.draw do
  post 'upload', to: 'home#upload'
  get 'upload', to: 'home#upload'
end
