Rails.application.routes.draw do
  get 'pages/index'
  devise_for :users

  get "pages/index"

  root "pages#index"
  
  mount Api => '/'
end
