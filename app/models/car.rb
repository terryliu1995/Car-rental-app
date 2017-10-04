class Car < ActiveRecord::Base
  has_many :reservations

  validates :licencePlateNum, presence: true, length: { maximum: 7 }, uniqueness: { message: 'This car has been added' }
  validates :manufacturer, presence: true
  validates :model, presence: true
  validates :style, presence: true, inclusion: { in: %w[Seden Coupe SUV], message: 'Sytle should be Seden, Couple or SUV' }
  validates :location, presence: true
  validates :hourlyRentalRate, presence: true
  validates :status, presence: true, numericality: { only_integer: true }

  def info
    "#{manufacturer}|#{model}|#{style}|#{licencePlateNum}"
  end

  def current_reservation
    reservation = reservations.find_by(status: 0)
    reservation.update_status if reservation
    reservation
  end

  def availalbe_params(user_type, task, customer_id)
    if task
      task = task.to_i
    elsif 0 == user_type
      task = 0
    elsif [1, 2].include? user_type
      task = 2
    end
    customer_id = customer_id.to_i if customer_id
    url_params = {}

    url_params[:back] = "?task=#{task}"
    if user_type == 0
      @customer = Customer.find(customer_id)
      customer_reservation = @customer.current_reservation
      if customer_reservation
        if id == customer_reservation.car.id
          if 2 == status
            url_params[:checkout] = "?car_id=#{id}"
          elsif 1 == status
            url_params[:checkin] = "?task=#{task}&car_id=#{id}"
          end
        end
      elsif 0 == status
        url_params[:reserve] = "?task=#{task}&car_id=#{id}"
        url_params[:checkout] = "?car_id=#{id}"
      end
    elsif [1, 2].include?(user_type)
      if 1 == task # on behalf of user to rent car
        @customer = Customer.find(customer_id)
        if 0 == status
          url_params[:reserve] = "?task=#{task}&car_id=#{id}"
          url_params[:checkout] = "?task=#{task}&car_id=#{id}"
        end
      else
        url_params[:history] = "?task=2&car_id=#{id}"
        if 2 == status
          url_params[:checkout] = "?car_id=#{id}"
        elsif 1 == status
          url_params[:checkin] = "?task=#{task}&car_id=#{id}"
        end
      end
    end

    if @customer
      customer_id = @customer.id
      url_params[:reserve] += "&customer_id=#{customer_id}" if url_params[:reserve]
      url_params[:checkout] += "&customer_id=#{customer_id}" if url_params[:checkout]
      url_params[:back] += "&customer_id=#{customer_id}" if url_params[:back]
    end

    return url_params
  end
end
