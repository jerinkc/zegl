class UserQuery
  attr_reader :user

  def initialize(user)
    @user = user
    @amount_due = {}
    @amount_owe = {}
    @amount_total_balance = {}
    @amount_settled = {}
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

  def calculated_users_and_balances
    @friends_with_transactions ||= User.select('users.id, users.name,
                                      SUM(CASE
                                          WHEN users.id = receiver_transactions.spender_id THEN receiver_transactions.amount
                                          ELSE 0
                                          END) as amount_owe,
                                      SUM(CASE
                                          WHEN users.id = receiver_transactions.receiver_id THEN receiver_transactions.amount
                                          ELSE 0
                                          END) as amount_due')
                              .joins("LEFT JOIN transactions AS receiver_transactions ON receiver_transactions.receiver_id = users.id OR
                                        receiver_transactions.spender_id = users.id")
                              .where("receiver_transactions.spender_id != receiver_transactions.receiver_id AND
                                      users.id != :user_id AND
                                    (receiver_transactions.receiver_id = :user_id OR receiver_transactions.spender_id = :user_id)",
                                    user_id: user.id)
                              .group('users.id, users.name')

  end

  def total_amount_due
    @total_amount_due ||= calculated_users_and_balances.map(&:amount_due).sum
  end

  def total_amount_owe
    @total_amount_owe ||= calculated_users_and_balances.map(&:amount_owe).sum
  end

  def total_balance_amount
    @total_balance_amount ||= (total_amount_due - total_amount_owe)
  end

  def total_balance(person)
    amount_due(person) - amount_owe(person)
  end
end
