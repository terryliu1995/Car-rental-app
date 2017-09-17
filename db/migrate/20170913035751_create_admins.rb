class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.string :email
      t.string :name
      t.string :password
      t.integer :issuper

      t.timestamps null: false
    end
  end
end
