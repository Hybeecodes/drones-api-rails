class Drone < ApplicationRecord
  validates :serial_number, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 25 }
  validates :model, presence: true, inclusion: { in: %w[Lightweight Middleweight Heavyweight Cruiserweight] }
  validates :weight, presence: true, numericality: { greater_than: 0.0 }
  validates :battery, presence: true, numericality: { greater_than: 0.0 }
  validates :status, presence: true, inclusion: { in: %w[Idle Loading Loaded Delivering Delivered Returning] }
end
