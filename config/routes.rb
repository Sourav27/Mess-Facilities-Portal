Rails.application.routes.draw do
	resources :complaints, only: [:index, :new, :create, :destroy, :show]

	root 'complaints#index'

	get 'login' => 'oauth#index'
	delete 'logout'=>'oauth#signout'
end
