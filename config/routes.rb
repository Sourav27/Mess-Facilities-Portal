Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :complaints

  root 'complaints#index'

  get 'login' => 'oauth#index'
  delete 'logout'=>'oauth#signout'
end
