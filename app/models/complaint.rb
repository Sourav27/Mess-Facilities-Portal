class Complaint < ActiveRecord::Base
	mount_uploader :attachment, AttachmentUploader
	belongs_to :user
	belongs_to :category
	validates :title, presence: true
	validates :content, presence: true
end
