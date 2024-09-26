class Expense < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  has_many :transactions, as: :transactionable

  attr_accessor :amount
end
