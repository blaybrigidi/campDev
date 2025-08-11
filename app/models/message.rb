class Message < ApplicationRecord
  belongs_to :order
  belongs_to :user

  validates :text, presence: true, length: { maximum: 1000 }

  scope :ordered, -> { order(:created_at) }
end