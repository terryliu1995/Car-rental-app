class Car < ActiveRecord::Base
  has_many :reservations

  def current_reservation
    reservation = reservations.find_by(status: 0)
    reservation.update_status if reservation
    reservation
  end
end
