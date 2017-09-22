class ChangeLicensetypeToString < ActiveRecord::Migration
  def change
    remove_column :cars, :licencePlateNumber, :integer
    add_column :cars, :licencePlateNum, :string
  end
end
