Rails.application.routes.draw do
	resources :complaints, only: [:index, :new, :create, :destroy, :show]
	get 'complaints_all' => 'complaints#all'
	root 'complaints#index'

	get 'login' => 'oauth#index'
	delete 'logout'=>'oauth#signout'

	mount ActionCable.server => '/cable'
end
