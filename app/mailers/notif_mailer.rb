class NotifMailer < ApplicationMailer
	def notif(name,user,title,content,url)
		@name = name
		@user = user
		@title = title
		@content = content
		@url = url
		@smail=user+"@smail.iitm.ac.in"
		mail(to: @smail, subject: "Mess/Facilities complaint registered")
	end
	
	def coordnotif(name,user,title,content,url)
		@name = name
		@user = user
		@title = title
		@content = content
		@url = url
		mail(to: @user, subject: "New mess/facilities complaint registered")
	end
	
	def caterernotif(caterer,mail,title,content,url)
		@caterer = caterer
		@mail = mail
		@title = title
		@content = content
		@url = url
		mail(to: @mail, subject: "New mess/facilities complaint registered")
	end
end
