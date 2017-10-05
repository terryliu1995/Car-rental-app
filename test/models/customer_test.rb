require 'test_helper'

class CustomerTest < ActiveSupport::TestCase

  test "should not save customer without email" do
    @customer = Customer.new
    assert_not@customer.save, "Saved the customer without a eamil"
  end

  test "should not save customer if email is not unique" do
    @customer1 = Customer.new(email:'a@b.c')
    @customer2 = Customer.new(email:'a@b.c')
    @customer1.save
    assert_not@customer2.save, "Saved the customer if email is not unique"
  end

  test "should return current reservation of customer" do
    @reservation = Reservation.new
    @reservation.customer_id = 1
    @reservation.id = 1
    @reservation.status = 0
    @customer = Customer.new(email:'a@b.c', id:1)
    assert_equal  nil, @customer.current_reservation, "should return current reservation of customer"
  end
end
