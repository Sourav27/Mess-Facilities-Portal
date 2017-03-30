class Addpositiontomembers < ActiveRecord::Migration[5.0]
  def change
  	add_column :members, :position, :string
  end
end
