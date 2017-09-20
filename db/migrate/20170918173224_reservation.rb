class Reservation < ActiveRecord::Migration
  def change
    change_table :reservations do |t|
      t.datetime :reserved_time
      t.datetime :checkout_time
      t.datetime :end_time
      t.float :rental_charge
    end
  end
end
