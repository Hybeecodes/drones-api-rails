Rails.application.routes.draw do
  # custom routes
  post 'api/drones/register', to: 'drones#register', as: 'register_drone'
end
