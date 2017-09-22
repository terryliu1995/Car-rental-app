class Customer < ActiveRecord::Base
  has_secure_password
  has_many :reservations

  validates :email, uniqueness: true

  def current_reservation
    reservation = reservations.find_by(status: 0)
    reservation.update_status if reservation
    reservation
  end
end
