Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'
  get 'explore' => 'explore#index'
  get 'contact-us' => 'contact_us#index'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  namespace :admin do
    resources :countries, except: [:show]
    resources :photos, only: [:destroy]
    resources :resources, only: [:destroy]
    resources :related_links, only: [:destroy]
  end

  namespace :api do
    resources :icca_sites
    resources :countries
  end

  # Make sure this routeset is defined last
  comfy_route :cms_admin, :path => '/admin'
  comfy_route :cms, :path => '/', :sitemap => false
end
