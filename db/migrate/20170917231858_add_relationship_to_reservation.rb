class AddRelationshipToReservation < ActiveRecord::Migration
  def change
    change_table :reservations do |t|
      t.references :car
    end
  end
end
