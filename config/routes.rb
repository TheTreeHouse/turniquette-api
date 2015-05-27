Rails.application.routes.draw do
  namespace :api do
    get 'register' => 'registrations#create'
  end
end
