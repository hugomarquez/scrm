Rails.application.routes.draw do
  namespace :core, path:'/' do
    root to:'dashboard#index'
    devise_for :users, class_name:'Core::User', module: :devise, skip:[:registrations]

    resources :users, class_name:'Core::User', except:[:destroy] do
      get 'send_invite', on: :member
    end
  end

  namespace :crm, path: '/sales' do
    root to: 'dashboard#index'

    resources :accounts, class_name:'Crm::Account' do
      collection do
        get 'home'
        get 'lookup'
      end
    end

    resources :contacts, class_name:'Crm::Contact' do
      get 'home', on: :collection
    end

    resources :leads, class_name:'Crm::Lead' do
      get 'home', on: :collection
      post 'clone', on: :member
      post 'convert', on: :member
    end

    resources :deals, class_name:'Crm::Deal' do
      get 'home', on: :collection
    end
  end

  get 'home', to: 'home#index'
end
