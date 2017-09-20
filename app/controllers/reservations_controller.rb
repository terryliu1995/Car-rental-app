class ReservationsController < ApplicationController
  before_action :set_reservation, only: %i[show edit update destroy]
  before_action :set_status, only: %i[show index]

  # GET /reservations
  def index
    task = params[:task].to_i
    if task == 0
      @reservations = Reservation.all
    elsif task == 1
      @reservations = Reservation.where(customer_id: session[:user_id])
    elsif task == 2
      @reservations = Reservation.where(car_id: params[:car_id].to_i)
    else
      @reservations = []
    end
    @reservations.each do |r|
      r.update_status
    end
  end

  # GET /reservations/1
  def show
    @reservation.update_status
  end

  # GET /reservations/new
  def new
    @reservation = Reservation.new
    @car = Car.find(params[:car_id])
  end

  # GET /reservations/1/edit
  def edit; end

  # POST /reservations
  def create
    @reservation = Reservation.new(status: 0)

    if @reservation.update(reservation_params)
      @reservation.car.status = 2
      @reservation.car.save
      redirect_to @reservation, notice: 'Reservation was successfully created.'
    else
      render :new
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
    params.require(:reservation).permit(:car_id, :customer_id, :reserved_time, :rental_charge)
  end

  def auto_close(reservation)
    Thread.new {
      sleep reservation.reserved_time - Time.new + 1800
      if reservation.status == 0 && reservation.car.status == 2
        reservation.car.status = 0
        reservation.status = 1
        reservation.car.save
        reservation.save
      end
    }
  end
end
