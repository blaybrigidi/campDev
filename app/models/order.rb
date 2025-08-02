class Order < ApplicationRecord
  enum :order_status, { pending: 0, accepted: 1, completed: 2, cancelled: 3 }
  belongs_to :user
end