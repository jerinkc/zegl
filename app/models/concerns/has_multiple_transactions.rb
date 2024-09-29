module HasMultipleTransactions
  extend ActiveSupport::Concern

  included do
    attribute :date, :date
    attribute :payer_id, :integer
    attribute :receiver_ids, :integer, array: true
    attribute :total_amount, :decimal, precision: 10, scale: 2

    validates :total_amount, :date, :payer_id, :receiver_ids, presence: true
    validates :total_amount, numericality: { greater_than: 0 }

    has_many :transactions, as: :transactionable

    before_validation :build_transactions
  end

  def build_transactions
    amount, remaining = calculated_amount

    return unless amount.present?

    transactions_data = filtered_receiver_ids.map.with_index do |receiver_id, index|
      {
        date: date,
        amount: index.zero? ? amount + remaining : amount,
        total_amount: total_amount,
        spender_id: payer_id,
        receiver_id: receiver_id,
        transactionable: self
      }
    end

    transactions.build(transactions_data)
  end

  private

  def calculated_amount
    return [0, 0] if !total_amount.present? || total_amount.zero?

    shareable_amount = (total_amount / filtered_receiver_ids.length).round(2)
    remaining_amount = total_amount % shareable_amount

    [shareable_amount, remaining_amount]
  end

  def filtered_receiver_ids
    receiver_ids.reject(&:blank?).uniq
  end
end
