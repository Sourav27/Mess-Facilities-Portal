class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.string :user , null: false
      t.datetime :time , null: false

      t.timestamps null: false
    end
  end
end
