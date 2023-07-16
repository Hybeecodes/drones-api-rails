module Drones
  class RegisterDroneDto < ::Dry::Schema::Params
      define do
        required(:serial_number).filled(:string)
        required(:model).filled(:string).value(included_in?: %w[Lightweight Middleweight Heavyweight Cruiserweight])
        required(:weight).filled(:float)
        required(:battery).filled(:float)
        required(:status).filled(:string).value(included_in?: %w[Idle Loading Loaded Delivering Delivered Returning])
      end
  end
end
