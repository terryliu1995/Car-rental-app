class Car < ActiveRecord::Base
  has_many :reservations
end
