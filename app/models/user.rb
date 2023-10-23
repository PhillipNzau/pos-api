class User < ApplicationRecord
  has_secure_password

  has_many :orders
  
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true
  validate :password_length

  private

  def password_length
    if password.present? && password.length < 6
      errors.add(:password, "is too short (minimum is 6 characters)")
    end
  end
end
