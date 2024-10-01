class DashboardController < ApplicationController
  def show
    user_query = UserQuery.new(current_user)
    @friends_transactions = user_query.calculated_users_and_balances
    @transactions_summary = {
                              total_amount_due: user_query.total_amount_due,
                              total_amount_owe: user_query.total_amount_owe,
                              total_balance_amount: user_query.total_balance_amount
                            }
  end
end
