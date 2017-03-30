class Addcheckandcomplainttype < ActiveRecord::Migration[5.0]
  def change
  	add_column :complaints, :complaint_category_ids, :string
	add_column :complaints, :contacted, :boolean, default: false
  end
end
