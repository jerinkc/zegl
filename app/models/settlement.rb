class Settlement < ApplicationRecord
  include HasTransaction

  belongs_to :user
end
