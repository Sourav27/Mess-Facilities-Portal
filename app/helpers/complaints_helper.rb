module ComplaintsHelper
	def is_relaventmember2?(complaint)
		if Member.where(username: current_user.username).present?
			@ids = Member.find_by(username: current_user.username).categories
			if !@ids.nil?
				@ids = @ids.split(",")
				@ids.each do |value|
					@tempid = complaint.category_id
				    if value.to_i==@tempid
				    	return true 
				    else
				    	return false
				    end
				end
			else
				return false
			end

		else
			return false
		end
	end

	def is_owner?(complaint)
		if current_user.id == complaint.user_id
			return true
		else
			return false
		end
	end

end
