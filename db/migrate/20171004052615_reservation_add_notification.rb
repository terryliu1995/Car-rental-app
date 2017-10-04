class ReservationAddNotification < ActiveRecord::Migration
  def change
    change_table :reservations do |t|
      t.boolean :unread_message
      t.boolean :unread_email
    end
  end
end
