module HasMultipleTransactions
  extend ActiveSupport::Concern

  included do
    attribute :amount, :integer
    attribute :date, :date
    attribute :payer_id, :integer
    attribute :receiver_ids, :integer, array: true

    validates :amount, :date, :payer_id, :receiver_ids, presence: true

    has_many :transactions, as: :transactionable

    before_validation :build_transactions
  end

  def build_transactions
    amount, remaining = calculated_amount
    unique_receiver_ids = (receiver_ids << payer_id).uniq
    transactions_data = unique_receiver_ids.map.with_index do |receiver_id, index|
      {
        date: date,
        amount: index.zero? ? amount + remaining : amount,
        spender_id: payer_id,
        receiver_id: receiver_id,
        transactionable: self
      }
    end

    transactions.build(transactions_data)
  end

  private

  def calculated_amount
    shareable_amount = amount / receiver_ids.length
    remaining_amount = amount % shareable_amount

    [shareable_amount, remaining_amount]
  end
end
