class AppIntegrationChanges < ActiveRecord::Migration[5.0]
  def change
        remove_reference :messages, :complaint, foreign_key: true
  	add_column :complaints,:relation, :string, null: false
  	add_column :messages,:relation, :string, null: false
  	change_column :messages, :user_id, :string, null: false
  	change_column :complaints, :user_id, :string, null:false
  	remove_index :messages, :user_id
  	add_column :complaints, :resolved_by, :string, default: :null
  end
end
