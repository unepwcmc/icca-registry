Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'
  get 'search'     => 'search#show', as: 'search'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  namespace :admin do
    resources :countries, except: [:show]
    resources :icca_sites, except: [:show]
    resources :interest_submissions, only: [:index] do
      get 'download_csv', on: :collection
    end
    resources :photos, only: [:destroy]
    resources :resources, only: [:destroy]
    resources :related_links, only: [:destroy]
  end

  namespace :api do
    resources :icca_sites
    resources :countries
    resources :interest_submissions, only: [:create]
  end

  # News articles json
  get '/news-articles', to: 'news_articles#index', as: :news_articles

  scope "/:locale", locale: /en|es|fr/ do
    get '/', to: 'home#index', as: :locale_root
  end

  # Make sure this routeset is defined last
  comfy_route :cms_admin, :path => '/admin'
  comfy_route :cms, :path => '/', :sitemap => false
end
