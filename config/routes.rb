Whirlwind::Application.routes.draw do
  root to: 'playlists#index'

  get '/login', to: "sessions#new"

  match '/auth/rdio/callback', to: 'sessions#create', via: [:get, :post]
  match '/logout', to: 'sessions#destroy', via: [:get, :post]

  match '/helper', to: redirect('/helper.html'), via: [:get, :post]

  get '/playlists/:rdio_key' => 'playlists#show'
  get '/playlists' => 'playlists#index'
  match '/playlists/:rdio_key/add_song' => 'playlists#add_song', as: "add_song_to_playlist", via: [:get, :post]
  match '/playlists/:rdio_key/generate_access_code' => 'playlists#generate_access_code', as: "generate_access_code", via: [:get, :post]

  post '/connect' => 'connect#connect'

  match '/song_search' => 'song_search#search', as: "song_search", via: [:get, :post]

end
