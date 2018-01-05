Rails.application.routes.draw do
  post 'upload', to: 'home#upload'
  post 'delete', to: 'home#delete'
end
