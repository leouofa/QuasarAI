Rails.application.routes.draw do
  apipie
  root "page#index"

  # namespace :api, defaults: { format: 'json' } do
  #   namespace :v1 do
  #   end
  # end
end
