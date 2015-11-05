class CreateTrades < ActiveRecord::Migration
  def change
    create_table :trades do |t|
      t.string :symbol_traded
      t.integer :shares_traded
      t.decimal :total_amount_traded
      # t.references => t.string :user_id
      t.references  :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :trades, :symbol_traded
  end
end
