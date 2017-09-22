class AddManufacturerToCars < ActiveRecord::Migration
  def change
    add_column :cars, :manufacturer, :string
  end
end
