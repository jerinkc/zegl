class TransactionsSummaryPresenter
  attr_reader :current_user, :receiver

  def initialize(current_user, receiver)
    @current_user = current_user
    @receiver = receiver
    @user_query = UserQuery.new(current_user)
  end

  def amount_due
    format('$%.2f', @user_query.amount_due(receiver).to_f)
  end

  def amount_owe
    format('$%.2f', @user_query.amount_owe(receiver).to_f)
  end

  def total_balance
    balance = @user_query.total_balance(receiver).to_f

    (balance < 0 ? '-' : '+') + ' ' + format('$%.2f', balance.abs)
  end
end
