class CreateExpenses < ActiveRecord::Migration[6.1]
  def change
    create_table :expenses do |t|
      t.text :description
      t.references :creator, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
