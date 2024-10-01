class ExpensesController < ApplicationController
  def index
    redirect_to new_expense_path
  end

  def new
    @expense = Expense.new
    @users = User.select(:id, :name)
  end

  def create
    expense_params.merge(creator_id: current_user)
    @expense = Expense.new(expense_params.merge(additional_params))
    @users = User.select(:id, :name)

    if @expense.save
      redirect_to person_path(@expense.transactions.first.receiver_id)
    else
      render :new
    end
  end

  private

  def expense_params
    params.require(:expense).permit(:payer_id, :date, :description, :total_amount, receiver_ids: [])
  end

  def additional_params
    { creator_id: current_user.id }
  end
end
