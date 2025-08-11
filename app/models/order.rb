class Order < ApplicationRecord
  enum :order_status, { pending: 0, accepted: 1, completed: 2, cancelled: 3 }
  belongs_to :user
  belongs_to :service_provider, class_name: 'User', optional: true
  has_many :messages, dependent: :destroy
  
  validates :item_name, presence: true, length: { minimum: 2 }
  validates :location, presence: true
  validates :user_id, presence: true
  
  before_create :set_default_status

  def set_default_status
    self.order_status ||= :pending
end
end
