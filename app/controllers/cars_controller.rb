class CarsController < ApplicationController
  # Require user
  before_action :set_car, only: %i[show edit update destroy]

  # GET /cars
  def index
    @cars = Car.all
  end

  # GET /cars/1
  def show
    @reservation = @car.reservations.find_by(status: 0)
  end

  # GET /cars/new
  def new
    @car = Car.new
  end

  # GET /cars/1/edit
  def edit; end

  # POST /cars
  def create
    @car = Car.new(car_params)

    if @car.save
      redirect_to @car, notice: 'Car was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /cars/1
  def update
    if @car.update(car_params)
      redirect_to @car, notice: 'Car was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /cars/1
  def destroy
    @car.destroy
    redirect_to cars_url, notice: 'Car was successfully destroyed.'
  end

  def checkout
    @car = Car.find(params[:car_id].to_i)
    @car.status = 1
    @car.save
    user = current_user
    current_time = Time.zone.now

    # Change reservation
    unless (@reservation = @car.current_reservation)
      @reservation = Reservation.new
      @reservation.status = 0
      @reservation.reserved_time = current_time
      @reservation.car_id = @car.id
      @reservation.customer_id =  user.id
    end
    @reservation.checkout_time = current_time
    @reservation.save

    redirect_to @car
  end

  def checkin
    @car = Car.find(params[:car_id].to_i)
    @car.status = 0
    @car.save
    @reservation = @car.current_reservation

    @reservation.close_reservation

    redirect_to @reservation
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_car
    @car = Car.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def car_params
    params.require(:car).permit(:model, :style, :licencePlateNumber, :location, :status, :manufacturer, :hourlyRentalRate)
  end
end
