class Order < ApplicationRecord
  enum :order_status, { pending: 0, accepted: 1, completed: 2, cancelled: 3 }
  belongs_to :user
  before_create :set_default_status

  def set_default_status
    self.order_status ||= :pending
end
end
