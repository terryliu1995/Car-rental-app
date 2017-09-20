class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :status
      t.datetime :endTime

      t.references :customer
      t.timestamps null: false
    end
  end
end
