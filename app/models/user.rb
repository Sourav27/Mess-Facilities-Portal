class User < ApplicationRecord
	establish_connection :students_1617
	has_many :complaints, dependent: :destroy
	has_many :messages, dependent: :destroy
end
