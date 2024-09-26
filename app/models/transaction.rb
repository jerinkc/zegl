class Transaction < ApplicationRecord
  belongs_to :spender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  belongs_to :transactionable, polymorphic: true

  scope :paid_to, ->(user) { where(receiver_id: user.id) }
  scope :paid_by, ->(user) { where(spender_id: user.id) }

  validates :amount, presence: true
end
