class Complaint < ActiveRecord::Base
	belongs_to :user
	validates :title, presence: true
	validates :content, presence: true
	validates :category, presence: true
	validates :mess, presence: true
end
