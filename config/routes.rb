Rails.application.routes.draw do
  namespace :api do
    get 'register' => 'registrations#create'
    get 'login' => 'sessions#create'
    get 'logout' => 'sessions#destroy'
  end
end
