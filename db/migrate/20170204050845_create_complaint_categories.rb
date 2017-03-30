class CreateComplaintCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :complaint_categories do |t|
	t.string :name
    end
  end
end
