Rails.application.routes.draw do
  post 'submit', to: 'home#submit'
  get 'wakeup', to: 'home#wakeup'
end
