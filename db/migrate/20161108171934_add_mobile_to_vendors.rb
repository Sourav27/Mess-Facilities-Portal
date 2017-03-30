class AddMobileToVendors < ActiveRecord::Migration[5.0]
  def change
    add_column :vendors, :mobile, :integer
  end
end
