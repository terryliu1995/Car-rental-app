class ReservationsController < ApplicationController
  before_action :set_reservation, only: %i[show edit update destroy]
  before_action :set_status, only: %i[show index]

  # GET /reservations
  def index
    task = params[:task].to_i
    @user_type = session[:user_type]
    if task == 0
      @reservations = Reservation.all
    elsif task == 1
      @reservations = Reservation.where(customer_id: params[:customer_id].to_i)
    elsif task == 2
      @reservations = Reservation.where(car_id: params[:car_id].to_i)
    else
      @reservations = []
    end
    @reservations.each(&:update_status)
  end

  # GET /reservations/1
  def show
    @reservation.update_status
    car = @reservation.car
    @car_info = "#{car.manufacturer}|#{car.model}|#{car.style}|#{car.licencePlateNum}"
  end

  # GET /reservations/new
  def new
    @reservation = Reservation.new
    @car = Car.find(params[:car_id])
    customer_id = params[:customer_id].to_i
    @customer = if customer_id && customer_id > 0
                  Customer.find(params[:customer_id])
                else
                  Customer.find(session[:user_id])
                end
  end

  # GET /reservations/1/edit
  def edit; end

  # POST /reservations
  def create
    @reservation = Reservation.new(status: 0)

    if @reservation.update(reservation_params)
      time_diff = @reservation.reserved_time - Time.zone.now
      if time_diff < -1800 || time_diff > 3600 * 24 * 7
        @reservation.destroy
        redirect_to "#{new_reservation_path}?car_id=#{params[:reservation][:car_id]}&customer_id=#{params[:reservation][:customer_id]}", notice: 'Invalid reservation time!'
      else
        @reservation.car.status = 2
        @reservation.car.save
        redirect_to @reservation, notice: 'Reservation was successfully created.'
      end
    else
      redirect_to "#{new_reservation_path}?car_id=#{params[:reservation][:car_id]}&customer_id=#{params[:reservation][:customer_id]}", notice: 'Invalid reservation parameter!'
    end
  end

  # PATCH/PUT /reservations/1
  def update
    if @reservation.update(reservation_params)
      redirect_to @reservation, notice: 'Reservation was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /reservations/1
  def destroy
    @reservation.destroy
    redirect_to reservations_url, notice: 'Reservation was successfully destroyed.'
  end

  # CLOSE
  def close
    reservation = Reservation.find(params[:reservation_id].to_i)
    reservation.car.status = 0
    reservation.close_reservation
    redirect_to reservation, notice: 'Reservation was successfully closed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def set_status
    @status = %w[Active Closed]
  end

  # Only allow a trusted parameter "white list" through.
  def reservation_params
    params.require(:reservation).permit(:car_id, :customer_id, :reserved_time,
                                        :rental_charge)
  end

  def auto_close(reservation)
    Thread.new do
      sleep reservation.reserved_time - Time.new + 1800
      if reservation.status == 0 && reservation.car.status == 2
        reservation.car.status = 0
        reservation.status = 1
        reservation.car.save
        reservation.save
      end
    end
  end
end
