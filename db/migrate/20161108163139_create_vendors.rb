class CreateVendors < ActiveRecord::Migration[5.0]
  def change
    create_table :vendors do |t|
      t.integer :category_id
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
