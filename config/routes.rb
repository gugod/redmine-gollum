ActionController::Routing::Routes.draw do |map|
  map.resources :gollum, :path_prefix => '/projects/:project_id'
  map.resource  :gollum_wiki, :path_prefix => '/projects/:project_id'
end
