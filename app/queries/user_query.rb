class UserQuery < Struct.new(:user)
  def transactions_with(person)
    user.transactions_as_spender.paid_to(person)
      .or(user.transactions_as_receiver.paid_by(person))
  end

  def people_with_transactions
    @people = User.select('users.id, users.name')
                  .joins("LEFT JOIN transactions AS spender_transactions ON spender_transactions.spender_id = users.id")
                  .joins("LEFT JOIN transactions AS receiver_transactions ON receiver_transactions.receiver_id = users.id")
                  .group('users.id')
                  .having('COUNT(spender_transactions.id) > 0 OR COUNT(receiver_transactions.id) > 0')
  end
end
