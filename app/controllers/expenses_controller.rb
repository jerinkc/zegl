class ExpensesController < ApplicationController
  def index
    redirect_to new_expense_path
  end

  def new
    @expense = Expense.new
  end

  def create
    expense_params.merge(creator_id: current_user)
    @expense = Expense.new(expense_params.merge(additional_params))

    if @expense.save
      redirect_to person_path(transaction(@expense).receiver_id)
    else
      render :new
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:payer_id, :date, :description, :total_amount)
  end

  def additional_params #TODO: Add multiple dropdown select and replace receiver_ids static values
    { creator_id: current_user.id, receiver_ids: [3, 4, 5] }
  end

  def transaction(expense)
    expense.transactions.each { |t| return t if current_user.id != t.receiver_id }
  end
end
