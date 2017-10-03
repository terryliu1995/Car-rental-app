require 'active_record'
class Reservation < ActiveRecord::Base
  belongs_to :customer
  belongs_to :car

  def update_status
    current_time = Time.zone.now
    if car.status == 2 && current_time - reserved_time > 1800
      car.status = 0
      self.status = 1
    elsif status == 0 && car.status == 1
      update_rental_charge(current_time)
    end
    car.save
    save
    self
  end

  def close_reservation
    current_time = Time.zone.now
    self.status = 1
    self.end_time = current_time
    update_rental_charge(current_time)
    save
  end

  private

  def update_rental_charge(current_time)
    if checkout_time
    begin
      duration = [1, (current_time - checkout_time) / 3600].max
      self.rental_charge = car.hourlyRentalRate * duration
    rescue Exception => e
      puts e.to_s
    end
    else
      self.rental_charge = 0
    end
  end
end
