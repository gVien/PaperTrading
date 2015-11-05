class CreateWatchlists < ActiveRecord::Migration
  def change
    create_table :watchlists do |t|
      t.string :name
      # t.reference => t.string :user_id
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :watchlists, :name
  end
end
