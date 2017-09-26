class ReservationRemoveColomn < ActiveRecord::Migration
  def change
    remove_column :reservations, :endTime, :datetime
  end
end
