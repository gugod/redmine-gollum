resources :projects do
  resources :gollum_pages do
    collection do
      post 'preview'
    end
  end
  resource :gollum_wiki
end
