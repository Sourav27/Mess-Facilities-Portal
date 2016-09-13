Rails.application.routes.draw do
	resources :complaints, only: [:index, :new, :create, :destroy, :show]
	get 'complaints_all' => 'complaints#all'
	root 'complaints#index'
	get 'login' => 'sessions#new'
	resources :sessions,only: [:create]
	get 'logout' =>'sessions#destroy'
	# get 'login' => 'oauth#index'
	# delete 'logout'=>'oauth#signout'

	get 'resolve' => 'complaints#resolve'
	mount ActionCable.server => '/cable'
end
