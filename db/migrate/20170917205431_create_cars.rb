class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.string :model
      t.string :style
      t.integer :licencePlateNumber
      t.string :location
      t.integer :status
      t.float :hourlyRentalRate

      t.timestamps null: false
    end
  end
end
