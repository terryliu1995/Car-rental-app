class Car < ActiveRecord::Base
  has_many :reservations

  validates :licencePlateNumber, presence: true, length: { maximum: 7 }, uniqueness: {message: "This car has been added"}
  validates :manufacturer, presence: true
  validates :model, presence: true
  validates :style, presence: true, inclusion: { in: ["Seden", "Couple", "SUV"], message: "Sytle should be Seden, Couple or SUV"}
  validates :location, presence: true
  validates :hourlyRentalRate, presence: true
  validates :status, presence: true, numericality: { only_integer: true }
end
