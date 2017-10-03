class CarsController < ApplicationController
  # Require user
  before_action :set_car, only: %i[show edit update destroy]

  # GET /cars
  def index
    @task = params[:task].to_i
    @parameters = "&task=#{@task}"
    @cars = Car.all
    @car_status_default = 0
    if @task == 1 # on behalf of customer to rent car task = 1
      params[:sstatus] ||= 0
      @customer = Customer.find(params[:customer_id].to_i)
    elsif @task == 0 # customer reserve car  task = 2
      params[:sstatus] ||= 0
      @customer = current_user
    elsif @task == 2
      params[:sstatus] ||= '-1'
      @car_status_default = -1
    end
    @parameters += "&customer_id=#{@customer.id}" if @customer

    @cars = @cars.where(style: params[:sstyle]) if params[:sstyle] && params[:sstyle] != '---'
    @cars = @cars.where(location: params[:slocation]) if params[:slocation] && params[:slocation] != '---'
    @cars = @cars.where(model: params[:smodel]) if params[:smodel] && params[:smodel] != '---'
    @cars = @cars.where(manufacturer: params[:smanufacturer]) if params[:smanufacturer] && params[:smanufacturer] != '---'
    @cars = @cars.where(status: params[:sstatus].to_i) if params[:sstatus] && params[:sstatus] != '-1'
  end

  # GET /cars/1
  def show
    customer_id = params[:customer_id]
    customer_id = session[:user_id] unless customer_id
    @url_params = @car.availalbe_params(session[:user_type],
                                        params[:task], customer_id)
  end

  # GET /cars/new
  def new
    @car = Car.new
  end

  # GET /cars/1/edit
  def edit; end

  # POST /cars  git commit --amend --reset-author
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
    reservation = @car.current_reservation
    reservation.close_reservation if reservation
    @car.destroy
    redirect_to cars_url, notice: 'Car was successfully destroyed.'
  end

  def checkout
    @car = Car.find(params[:car_id].to_i)
    task = params[:task].to_i
    current_time = Time.zone.now
    user = if task == 1
             Customer.find(params[:customer_id].to_i)
           else
             current_user
           end
    # Change reservation
    unless (@reservation = @car.current_reservation)
      @reservation = Reservation.new
      @reservation.status = 0
      @reservation.reserved_time = current_time
      @reservation.car_id = @car.id
      @reservation.customer_id = user.id
    end
    @reservation.checkout_time = current_time
    @reservation.save
    @car.status = 1
    @car.save

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
    params.require(:car).permit(:model, :style, :licencePlateNum, :location, :status, :manufacturer, :hourlyRentalRate)
  end
end
