class Expense < ApplicationRecord
  belongs_to :user
  has_many :transactions, as: :transactionable

  attr_accessor :amount
end
