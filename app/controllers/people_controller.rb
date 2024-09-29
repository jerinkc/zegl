class PeopleController < ApplicationController
  def index
    user_query = UserQuery.new(current_user)
    @friends = user_query.people_with_transactions
  end

  def show
    user_query = UserQuery.new(current_user)
    @friends = user_query.people_with_transactions.order(created_at: :desc)
    @person = @friends.find_by(id: params[:id])

    return unless @person.present?

    @transactions_summary = TransactionsSummaryPresenter.new(current_user, @person)
    @transactions = user_query.transactions_with(@person).map do |t|
                      TransactionPresenter.new(t, current_user, @person)
                    end
  end
end
