class ChangeDataFormatInMicropost < ActiveRecord::Migration
  def change
    change_table :microposts do |t|
      t.change :content, :text
    end
  end
end
