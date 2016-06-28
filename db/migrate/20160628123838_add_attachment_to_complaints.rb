class AddAttachmentToComplaints < ActiveRecord::Migration[5.0]
  def change
  	add_column :complaints, :attachment, :string
  	remove_column :complaints, :mess, :string
  	remove_column :complaints, :category, :string
  	add_belongs_to :complaints, :category 
  end
end
