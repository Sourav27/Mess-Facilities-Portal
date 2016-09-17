class CreateMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :members do |t|

      t.string :username, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.string :mobile, null:false
      t.string :categories, null: false
    end
  end
end
