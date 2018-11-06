Rails.application.routes.draw do
  root to: 'home#index'

  namespace :core do
    devise_for :users, class_name:'Core::User', module: :devise, skip:[:registrations]

    resources :users, class_name:'Core::User', except:[:destroy] do
      get 'send_invite', on: :member
    end
  end

  namespace :crm, path: 'crm' do
    root to: 'dashboard#index'

    resources :accounts, class_name:'Crm::Account' do
      get 'home', on: :collection
    end
  end
end
