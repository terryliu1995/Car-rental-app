class Admin < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true, uniqueness:  {message: "This admin has been added"}
  validates :name, presence: true
  validates :issuper, presence: true, inclusion: {in: [1,2], message: "1 represent admin; 2 represent superadmin."}
  validates :password_digest, presence: true
end
