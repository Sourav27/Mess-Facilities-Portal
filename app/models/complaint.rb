class Complaint < ApplicationRecord
	belongs_to :category
	attr_accessor :mess_id, :facility_id, :category_type 	
	validates :title, presence: true
	validates :content, presence: true
	validates :contacted, acceptance: true
	validates :complaint_category_ids, presence: true
	#before_validation do
	 # self.complaint_category_ids.gsub!(/[\[\]\"\s+]/, "") if attribute_present?("complaint_category_ids")
	#end
end
