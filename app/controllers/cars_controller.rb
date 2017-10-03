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
    elsif 2 == @task
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
    @url = {}
    user_type = session[:user_type]
    if params[:task]
      task = params[:task].to_i
    elsif 0 == user_type
      task = 0
    elsif [1, 2].include? user_type
      task = 2
    end
    car_id = @car.id

    @url[:back] = "#{cars_path}?task=#{task}"
    if user_type == 0
      @customer = current_user
      customer_reservation = @customer.current_reservation
      if customer_reservation
        if @car.id == customer_reservation.car.id
          if @car.status == 2
            @url[:checkout] = "#{checkout_path}?car_id=#{car_id}"
          elsif @car.status == 1
            @url[:checkin] = "#{checkin_path}?task=#{task}&car_id=#{car_id}"
          end
        end
      elsif @car.status == 0
        @url[:reserve] = "#{new_reservation_path}?task=#{task}&car_id=#{car_id}"
      end
    elsif [1, 2].include?(user_type)
      if task == 1 # on behalf of user to rent car
        @customer = Customer.find(params[:customer_id].to_i)
        @url[:reserve] = "#{new_reservation_path}?task=#{task}&car_id=#{car_id}" if 0 == @car.status
      else
        @url[:history] = "#{reservations_path}?task=2&car_id=#{car_id}"
        if @car.status == 2
          @url[:checkout] = "#{checkout_path}?car_id=#{car_id}"
        elsif @car.status == 1
          @url[:checkin] = "#{checkin_path}?task=#{task}&car_id=#{car_id}"
        end
      end
    end

    if @customer
      customer_id = @customer.id
      @url[:reserve] += "&customer_id=#{customer_id}" if @url[:reserve]
      @url[:checkout] += "&customer_id=#{customer_id}" if @url[:checkout]
      @url[:back] += "&customer_id=#{customer_id}" if @url[:back]
    end
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
