class Order < ApplicationRecord
  enum status : {pending:0, accepted:1, completed:2,cancelled:3}
  belongs_to :user
end
