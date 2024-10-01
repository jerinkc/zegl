class Expense < ApplicationRecord
  include HasMultipleTransactions

  attr_accessor :share_with_people_ids

  belongs_to :creator, class_name: 'User'

  validate :creator_is_participant?

  private

  def creator_is_participant?
    return if participant_ids.include? creator_id

    errors.add(:creator_id, 'not a participant')
  end
end
