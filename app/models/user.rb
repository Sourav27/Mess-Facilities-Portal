class User < ActiveRecord::Base
	establish_connection :students_1617
	self.primary_key = "id"
	has_many :complaints, dependent: :destroy
end
