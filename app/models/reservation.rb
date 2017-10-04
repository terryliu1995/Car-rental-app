require 'active_record'
class Reservation < ActiveRecord::Base
  belongs_to :customer
  belongs_to :car

  def update_status
    if status == 0
      current_time = Time.zone.now
      if car.status == 2 && current_time - reserved_time > 1800
        car.status = 0
        self.status = 1
      elsif car.status == 1
        update_rental_charge(current_time)
      end
      car.save
      save
    end
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
      car = self.car
      duration = (current_time - checkout_time) / 3600
      if duration >= reserved_hours
        duration = reserved_hours
        car.status = 0
        car.save
        self.status = 1
        self.end_time = current_time
        self.unread_email = true
        self.unread_message = true
      end
      self.rental_charge = car.hourlyRentalRate * [1, duration].max
    rescue Exception => e
      puts e.to_s
    end
    else
      self.rental_charge = 0
    end
  end
end
