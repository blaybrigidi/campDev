class User < ApplicationRecord
  has_secure_password
  has_many :orders, dependent: :destroy
  has_many :messages, dependent: :destroy
  
  validates :name, presence: true, length: { minimum: 2 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone_number, presence: true
  validates :year, presence: true
  validates :api_key, uniqueness: true, allow_nil: true
  
  before_create :generate_api_key
  
  private
  
  def generate_api_key
    self.api_key = SecureRandom.hex(32)
  end
end
