class CreateTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :transactions do |t|
      t.date :date
      t.decimal :amount, precision: 10, scale: 2, null: false, default: 0

      t.references :spender, null: false, foreign_key: { to_table: :users }
      t.references :receiver, null: false, foreign_key: { to_table: :users }
      t.references :transactionable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
