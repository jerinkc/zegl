class TransactionPresenter
  attr_reader :transaction, :current_user, :person

  def initialize(transaction, current_user, person)
    @transaction = transaction
    @current_user = current_user
    @person = person
  end

  def date
    transaction.date&.strftime('%b %d').upcase
  end

  def title
    title = transaction.transactionable.send(title_key)

    title.present? ? title : "Transaction - #{transaction.transactionable.class}"
  end

  def paid_by
    "#{ transaction.spender_id == current_user.id ? 'you' : person.first_name } paid"
  end

  def total_amount
    format('$%.2f', transaction.total_amount.to_f)
  end

  def transfer_intent
    if type == :settle
      "#{ sender_name } settled #{ recipient_name }"
    else
      "#{ sender_name } lent #{ recipient_name }"
    end
  end

  def amount
    format('$%.2f', transaction.amount.to_f)
  end

  def sender_name
    transaction.spender_id == current_user.id ? 'you' : person.first_name
  end

  def recipient_name
    transaction.receiver_id == current_user.id ? 'you' : person.first_name
  end

  private

  def type
    if transaction.transactionable.class == Settlement
      :settle
    elsif current_user.id == transaction.spender_id
      :lent
    elsif current_user.id == transaction.receiver_id
      :borrow
    end
  end

  def title_key
    {
      expense: :description,
      settlement: :notes
    }[transaction.transactionable_type.downcase.to_sym]
  end
end
