Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users, class_name:'Core::User', skip:[:registrations]

  namespace :crm, path: 'crm' do
    root to: 'dashboard#index'

    resources :accounts, class_name:'Crm::Account' do
      get 'home', on: :collection
    end
  end
end
