class PeopleController < ApplicationController
  def show
    user_query = UserQuery.new(current_user)
    @friends = user_query.people_with_transactions.order(created_at: :desc)
    @person = @friends.find_by(id: selected_person_id)

    # redirect, when navigating to person with no transactions
    @person =  @friends.find_by(id: current_user.id) if !@person.present?

    @transactions_summary = TransactionsSummaryPresenter.new(current_user, @person)
    @transactions = user_query.transactions_with(@person).map do |t|
                      TransactionPresenter.new(t, current_user, @person)
                    end
  end

  private

  def selected_person_id
    params[:id] || current_user.id
  end
end
