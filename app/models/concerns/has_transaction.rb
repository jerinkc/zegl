module HasTransaction
  extend ActiveSupport::Concern

  attr_accessor :amount, :date, :payer_id, :receiver_id

  included do
    has_one :associated_transaction, as: :transactionable, class_name: 'Transaction'

    attribute :date, :date
    attribute :payer_id, :integer
    attribute :receiver_id, :integer
    attribute :amount, :decimal, precision: 10, scale: 2

    validates :amount, :date, :payer_id, :receiver_id, presence: true
    validates :amount, numericality: { greater_than: 0 }

    before_validation :build_transaction
  end

  def build_transaction
    transaction_data = {
                          date: date,
                          amount: amount,
                          total_amount: amount,
                          spender_id: payer_id,
                          receiver_id: receiver_id,
                        }

    build_associated_transaction(transaction_data)
  end
end
