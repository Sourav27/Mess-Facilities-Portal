class NotifMailer < ApplicationMailer
	default from: "Mess Complaint Portal"

	def notif(user,title,content)
		@user = user
		@title = title
		@content = content
		@smail=user+"@smail.iitm.ac.in"
		mail(to: @smail, subject: @title)
	end
end
