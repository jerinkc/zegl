class CreateSettlements < ActiveRecord::Migration[6.1]
  def change
    create_table :settlements do |t|
      t.text :notes
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
