class CreatePortfolios < ActiveRecord::Migration
  def change
    create_table :portfolios do |t|
      t.string      :symbol
      t.string      :company_name
      t.integer     :quantity
      t.decimal     :average_price
      t.references  :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :portfolios, :symbol, unique: true
  end
end
