class NotifMailer < ApplicationMailer
	def notif(user,title,url)
		@user = user
		@title = title
		@url = url
		@smail=user+"@smail.iitm.ac.in"
		mail(to: @smail, subject: @title)
	end
end
