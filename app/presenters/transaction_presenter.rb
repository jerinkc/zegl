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
    transaction.transactionable.description
  end

  def paid_by
    "#{ transaction.spender_id == current_user.id ? 'you' : person.first_name } paid"
  end

  def total_amount
    format('$%.2f', transaction.total_amount.to_f)
  end

  def transfer_intent
    "#{ sender_name } lent #{ recipient_name }"
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
    if current_user.id == transaction.spender_id
      :lent
    elsif current_user.id == transaction.receiver_id
      :borrow
    end
  end
end
