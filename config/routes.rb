Rails.application.routes.draw do
  namespace :core, path:'/' do

    root to:'dashboard#dashboard'
    get 'calendar', to:'dashboard#calendar'
    resources :tasks, class_name:'Core::Task', except:[:show]

    devise_for :users, class_name:'Core::User', module: :devise, skip:[:registrations]

    resources :users, class_name:'Core::User', except:[:destroy] do
      get 'send_invite', on: :member
      get 'lookup', on: :collection
    end
  end

  namespace :crm, path: '/sales' do

    resources :accounts, class_name:'Crm::Account' do
      get 'lookup', on: :collection
    end

    resources :contacts, class_name:'Crm::Contact' do
      get 'lookup', on: :collection
    end

    resources :leads, class_name:'Crm::Lead' do
      get 'lookup', on: :collection
      post 'clone', on: :member
      post 'convert', on: :member
    end

    resources :deals, class_name:'Crm::Deal' do
      get 'lookup', on: :collection
    end
  end

  get 'home', to: 'home#index'
end
