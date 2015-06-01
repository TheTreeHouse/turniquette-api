Rails.application.routes.draw do
  namespace :v1 do
    get 'register' => 'registrations#create'
  end
end
