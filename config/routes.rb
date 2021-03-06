Rails.application.routes.draw do
  namespace :v1 do
    get 'register' => 'registrations#create'
    get 'login' => 'sessions#create'
    get 'logout' => 'sessions#destroy'

    resources :events, except: [:edit, :new]
    resources :invitations, only: [:create]
  end
end
