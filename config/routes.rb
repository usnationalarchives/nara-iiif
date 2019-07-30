Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :posts
  resources :items

  get "items/viewer/:id", to: "viewer#show", as: "item_viewer"

  # api_version(:module => "v0.1.0", :header => {:name => "Accept", :value => "application/iiif.nara.gove; version=1"}) do
  api_version(:module => "V1", :path => {:value => "v1"}, :defaults => {:format => :json}) do
    resources :manifests
  end

end
