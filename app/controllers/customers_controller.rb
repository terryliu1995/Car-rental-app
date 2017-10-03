class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  before_action :require_user, only: [:index, :show, :edit, :update, :destroy]

  # GET /customers
  def index
    @customers = Customer.all
  end

  # GET /customers/1
  def show
    @reservation = @customer.current_reservation
    @url = {}
    user_type = session[:user_type]
    @url[:history] = "#{reservations_path}?task=1&customer_id=#{@customer.id}"
    if 0 == user_type
      @url[:edit] = edit_customer_path(@customer)
      @url[:rent_car] = "#{cars_path}?task=0"
    elsif [1, 2].include? user_type
      @url[:back] = customers_path
    end
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers
  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      if !current_user
        session[:user_type] = 0
        session[:user_id] = @customer.id
      end
      redirect_to @customer, notice: 'Customer was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /customers/1
  def update
    if @customer.update(customer_params)
      redirect_to @customer, notice: 'Customer was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /customers/1
  def destroy
    @customer.destroy
    redirect_to customers_url, notice: 'Customer was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def customer_params
      params.require(:customer).permit(:email, :name, :password)
    end
end
