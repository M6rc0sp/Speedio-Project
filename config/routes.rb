Rails.application.routes.draw do
  root 'website#index'  # Rota para a página principal

  post '/save_info', to: 'website#save_info'
  get '/get_info/:id', to: 'website#get_info'
end
