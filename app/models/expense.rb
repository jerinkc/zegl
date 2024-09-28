class Expense < ApplicationRecord
  include HasMultipleTransactions

  attr_accessor :share_with_people_ids

  belongs_to :creator, class_name: 'User'
end
