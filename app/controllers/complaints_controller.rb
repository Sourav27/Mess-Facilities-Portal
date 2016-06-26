class ComplaintsController < ApplicationController
	before_action :authenticate_user!

	def index
		@complaints = Complaint.order('created_at').all
	end

	def new
		@complaint =  Complaint.new
	end

	def create
		@complaint =  Complaint.new(complaint_params)
		@complaint.user_id = current_user.id
		if @complaint.save
			redirect_to root_url
		else
			render new
		end
	end
	private

	def authenticate_user!
		unless logged_in?
		  store_location
		  redirect_to url_for(:controller=>'oauth',:action=>'index'), alert: "You need to sign in before continuing."
		end
	end

	def complaint_params
	  params.require(:complaint).permit(:title, :content, :category, :mess)
	end
end
