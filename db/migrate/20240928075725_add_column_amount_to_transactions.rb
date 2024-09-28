class AddColumnAmountToTransactions < ActiveRecord::Migration[6.1]
  def change
    add_column :transactions, :total_amount, :decimal, precision: 10, scale: 2, null: false, default: 0
  end
end
