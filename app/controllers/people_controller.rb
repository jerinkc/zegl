class PeopleController < ApplicationController
  def show
    #TODO: Imporve

    @person = User.find(params[:id])
    @person_spend = @person.transactions_as_spender.paid_to(current_user)
    @person_received = @person.transactions_as_reciever.paid_by(current_user)
    @friends_owes_and_owed = User.where('id IN (?)', @person_spend.pluck(:receiver_id) + @person_received.pluck(:spender_id))
                                 .pluck(:id, :email)
  end
end
