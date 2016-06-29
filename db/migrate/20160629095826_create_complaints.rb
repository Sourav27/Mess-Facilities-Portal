class CreateComplaints < ActiveRecord::Migration[5.0]
  def change
    create_table :complaints do |t|
    	t.belongs_to :user, null: false
    	t.string :title, null: false
    	t.text :content, null: false
    	t.belongs_to :category, null: false
    	t.string :attachment
    	t.boolean :solved, null: false, default: false
    	t.timestamps null: false
    end
  end
end
