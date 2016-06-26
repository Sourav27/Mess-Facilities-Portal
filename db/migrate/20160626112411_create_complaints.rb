class CreateComplaints < ActiveRecord::Migration
  def change
    create_table :complaints do |t|
      t.belongs_to :user, null: false
      t.string :title, null: false
      t.text :content, null: false
      t.string :category, null: false
      t.string :mess, null: false
      t.boolean :solved, null: false, default: false
      t.timestamps null: false
    end
    add_index :complaints, :user_id
  end
end
