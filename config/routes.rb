Spree::Core::Engine.routes.draw do
  resources :subscriptions, :only => :create

  namespace :admin do
    resource :mailchimp_gibbon_settings
  end
end
