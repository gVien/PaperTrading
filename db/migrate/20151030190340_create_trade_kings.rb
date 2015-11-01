class CreateTradeKings < ActiveRecord::Migration
  def change
    create_table :trade_kings do |t|

      t.timestamps null: false
    end
  end
end
