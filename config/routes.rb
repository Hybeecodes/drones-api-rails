Rails.application.routes.draw do
  # custom routes
  post 'api/drones/register', to: 'drones#register', as: 'register_drone'
  post 'api/drones/:drone_id/load', to: 'drones#load', as: 'load_drone'
  get 'api/drones/:drone_id/medications', to: 'drones#drone_medications', as: 'drone_medications'
  get 'api/drones', to: 'drones#get_drones', as: 'get_drones'
  get 'api/drones/:drone_id', to: 'drones#get_drone', as: 'get_drone'
end
