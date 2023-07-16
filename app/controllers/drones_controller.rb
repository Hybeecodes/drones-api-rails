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

  def load
    payload = get_drone_medication_params
    drone_id = payload["drone_id"]
    # find drone and medications by id
    drone = Drone.find_by(id: drone_id)
    puts "Drone: #{drone["weight"]}"
    unless drone
      return render json: { message: "Drone with id '#{drone_id}' not found" }, status: :not_found
    end
    # we can't load a drone when the battery is less than 25%
    if drone.battery < 25
      return render json: { message: "Drone with id '#{drone_id}' has less than 25% battery" }, status: :bad_request
    end
    drone_medications = drone.medications
    meditation_payload = payload["medications"]
    # add each medication to the drone
    meditation_payload.each do |medication|
      #check if medication code already exists
      existing_medication = drone_medications.find_by(code: medication["code"])
      if existing_medication
        return render json: { message: "Medication with code '#{medication["code"]}' has already been loaded" }, status: :bad_request
      end
    end
    # calculate total weight of already loaded medications
    total_weight = drone_medications.sum(:weight)
    # calculate total weight of new medications
    meditation_payload.each do |medication|
      total_weight += medication["weight"]
    end
    # check if total weight of new medications is greater than drone weight
    if total_weight > drone.weight
      return render json: { message: "Total weight of medications is greater than drone weight" }, status: :bad_request
    end
    # add each medication to the drone
    begin
      meditation_payload.each do |medication|
        drone.medications.create(medication)
      end
      # update drone status to loaded
      drone.update(status: "Loaded")
      render json: { message: "Medications loaded successfully", drone: drone }, status: :ok
      return
    rescue => e
      puts "Unable to load medications: #{e.message.to_s}"
      render json: { message: 'Sorry, Unable to load medications!' }, status: :internal_server_error
      return
    end
  end

  def drone_medications
    drone_id = params["drone_id"]
    drone = Drone.find_by(id: drone_id)
    unless drone
      return render json: { message: "Drone with id '#{drone_id}' not found" }, status: :not_found
    end
    drone_medications = drone.medications
    render json: { message: "Drone medications", medications: drone_medications }, status: :ok
  end

  def get_drones
    drones = Drone.all
    render json: { message: "Drones", drones: drones }, status: :ok
  end

  def get_drone
    drone_id = params["drone_id"]
    drone = Drone.find_by(id: drone_id)
    unless drone
      return render json: { message: "Drone with id '#{drone_id}' not found" }, status: :not_found
    end
    render json: { message: "Drone", drone: drone }, status: :ok
  end

  private

  def drone_params
    puts "params: #{params}"
    params.require(:drone).permit(:serial_number, :model, :weight, :battery, :status)
  end

  def get_drone_medication_params
    #medications is an array of medication objects
    # we also need the drone id
    params.permit(:drone, :drone_id, medications: [:code, :name, :weight, :image_url])
  end
end
