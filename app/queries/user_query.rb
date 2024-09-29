class UserQuery
  attr_reader :user

  def initialize(user)
    @user = user
    @amount_due = {}
    @amount_owe = {}
    @amount_total_balance = {}
  end

  def transactions_with(person)
    user.transactions_as_spender.paid_to(person)
      .or(user.transactions_as_receiver.paid_by(person))
  end

  def people_with_transactions
    @people = User.select('users.id, users.name')
                  .joins("LEFT JOIN transactions AS spender_transactions ON spender_transactions.spender_id = users.id")
                  .joins("LEFT JOIN transactions AS receiver_transactions ON receiver_transactions.receiver_id = users.id")
                  .where('(spender_transactions.spender_id = :user_id OR spender_transactions.receiver_id = :user_id) OR
                          (receiver_transactions.spender_id = :user_id OR receiver_transactions.receiver_id = :user_id)',
                          user_id: user.id)
                  .group('users.id')
                  .having('COUNT(spender_transactions.id) > 0 OR COUNT(receiver_transactions.id) > 0')
  end

  def amount_due(person)
    @amount_due[person.id] ||= user.transactions_as_spender.paid_to(person).sum('transactions.amount')
  end

  def amount_owe(person)
    @amount_owe[person.id] ||= user.transactions_as_receiver.paid_by(person).sum('transactions.amount')
  end

  def total_balance(person)
    amount_due(person) - amount_owe(person)
  end
end
