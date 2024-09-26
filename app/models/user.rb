class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :expenses
  has_many :settlements
  has_many :transactions_as_spender, class_name: 'Transaction', foreign_key: 'spender_id'
  has_many :transactions_as_reciever, class_name: 'Transaction', foreign_key: 'receiver_id'
end
