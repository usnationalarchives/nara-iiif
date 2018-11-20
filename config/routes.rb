Rails.application.routes.draw do

  Tolaria.draw_routes(self)

  namespace :admin do
    # Deisgnateable types
    [].each do |key|
      put "#{key}/:id/designate", to:"#{key}#designate"
      put "#{key}/:id/undesignate", to:"#{key}#undesignate"
    end

    # Prioritizable types
    [].each do |key|
      put "#{key}/:id/move_up", to:"#{key}#move_up"
      put "#{key}/:id/move_down", to:"#{key}#move_down"
    end

    # Collection Prioritizable types
    [].each do |key|
      put "#{key}/:id/move_up_in_collection", to:"#{key}#move_up_in_collection"
      put "#{key}/:id/move_down_in_collection", to:"#{key}#move_down_in_collection"
    end

    # s3_uploader field support
    post "api/presigned_post", to:"presigned_post#create"
  end

  # Prototypes
  get "prototypes", to: "prototypes#index", as:"prototypes_index"
  get "prototypes/form", to:"prototypes#form", as:"prototypes_form"
  get "prototypes/scripts", to:"prototypes#scripts", as:"prototypes_scripts"

  # Homepage
  root to:"homepage#index"

  # Sitemap
  get "sitemap", to:"sitemap#sitemap", as:"sitemap"

  # Catchall route
  match "*path", to:"application#redirect_or_http404", via: :all

end
