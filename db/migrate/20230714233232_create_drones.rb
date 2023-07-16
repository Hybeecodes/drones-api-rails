class CreateDrones < ActiveRecord::Migration[7.0]
  def change
    create_table :drones do |t|
      t.string :serial_number
      t.column :model, "ENUM('Lightweight', 'Middleweight', 'Heavyweight', 'Cruiserweight')"
      t.float :weight
      t.float :battery
      t.column :status, "ENUM('Idle', 'Loading', 'Loaded', 'Delivering', 'Delivered', 'Returning')"
      t.timestamps
    end
  end
end
