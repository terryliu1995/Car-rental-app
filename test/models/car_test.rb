require 'test_helper'

class CarTest < ActiveSupport::TestCase

  test "should not save car whose licenceNumber is to long" do
    @car = Car.new(manufacturer:'Honda', model:'Civic', style:'Seden',
                     location:'raleigh', status:0, hourlyRentalRate:13, licencePlateNum:'123321123321' )
    assert_not @car.save, "Saved the admin without a issupper"
  end

  test "should not save car if style is not suv, seden or coupe" do
    @car = Car.new(manufacturer:'Honda', model:'Civic', style:'pikaqiu',
                    location:'raleigh', status:0, hourlyRentalRate:13, licencePlateNum:'123321123321' )
    assert_not @car.save, "should not save car if style is not suv, seden or coupe"
  end
end
