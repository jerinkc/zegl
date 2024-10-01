class SettlementsController < ApplicationController
  before_action :instatiate_data, only: [:new]

  def index
    redirect_to person_path(params[:person_id])
  end

  def new
    @settlement = Settlement.new
  end

  def create
    @settlement = Settlement.new(settlement_params)

    if @settlement.save
      redirect_to person_path(params[:person_id])
    else
      instatiate_data

      render :new
    end
  end

  private

  def settlement_params
    required = params.require(:settlement)
                     .permit(:notes, :amount, :date)
                     .merge(additional_params)
  end

  def instatiate_data
    user_query = UserQuery.new(current_user)
    @friends = user_query.people_with_transactions.order(created_at: :desc)
    @person = @friends.find_by(id: params[:person_id])
    @transactions_summary = TransactionsSummaryPresenter.new(current_user, @person)
  end

  def additional_params
    { payer_id: current_user.id, receiver_id: params[:person_id], user_id: current_user.id }
  end
end
