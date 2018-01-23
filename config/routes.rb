Rails.application.routes.draw do
  mount ShopifyApp::Engine, at: '/'
  post 'upload', to: 'home#upload'
  post 'delete', to: 'home#delete'
  post 'submit', to: 'home#submit'
end
