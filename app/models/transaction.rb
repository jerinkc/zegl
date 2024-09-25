class Transaction < ApplicationRecord
  belongs_to :spender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  belongs_to :transactionable, polymorphic: true

  validates :amount, presence: true
end
