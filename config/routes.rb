Rails.application.routes.draw do
  # custom routes
  post 'api/drones/register', to: 'drones#register', as: 'register_drone'
  post 'api/drones/:drone_id/load', to: 'drones#load', as: 'load_drone'
end
