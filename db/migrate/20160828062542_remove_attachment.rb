class RemoveAttachment < ActiveRecord::Migration[5.0]
  def change
  	remove_column :complaints, :attachment
  end
end
