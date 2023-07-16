class DronesController < ApplicationController
  def register
    payload = drone_params
    existing_drone = Drone.find_by(serial_number: payload["serial_number"])
    if existing_drone
      render json: { message: "Drone with serial number '#{payload["serial_number"]}' already exists" }, status: :bad_request
    else
      begin
        payload["status"] = "Idle"
        drone = Drone.create(payload)
        if drone.invalid? && drone.errors.full_messages
          render json: { message: drone.errors.full_messages }, status: :bad_request
        else
          render json: { message: "Drone with serial number #{payload["serial_number"]} registered successfully" }, status: :created
        end
      rescue => e
        puts "Unable to register drone: #{e.message.to_s}"
        render json: { message: 'Sorry, Unable to register drone!' }, status: :internal_server_error
      end
    end
  end

  private

  def drone_params
    puts "params: #{params}"
    params.require(:drone).permit(:serial_number, :model, :weight, :battery, :status)
  end

  def validate_params!(schema)
    result = schema.call(params.to_unsafe_hash)

    if result.success?
      result.to_h
    else
      raise ActionController::BadRequest, 'Invalid HTTP parameters.'
    end
  end
end
