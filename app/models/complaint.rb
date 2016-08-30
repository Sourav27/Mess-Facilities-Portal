class Complaint < ApplicationRecord
	belongs_to :user
	belongs_to :category
	has_many :messages, dependent: :destroy
	validates :title, presence: true
	validates :content, presence: true
end
