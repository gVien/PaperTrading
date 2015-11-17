class RenameMicropostsToPosts < ActiveRecord::Migration
  def change
    rename_table :microposts, :posts
  end
end
