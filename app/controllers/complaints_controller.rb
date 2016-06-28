class ComplaintsController < ApplicationController
	before_action :set_complaint, only: [:show,:create,:destroy]
	before_action :authenticate_user!

	def index
		@complaints = current_user.complaints.order('created_at').all
	end

	def new
		@complaint =  Complaint.new
	end

	def show
		
	end

	def create
		@complaint =  Complaint.new(complaint_params)
		@complaint.user_id = current_user.id
		
		respond_to do |format|
			if @complaint.save
				format.html { redirect_to @comlaint, notice: "Complaint registered successfully!" }
				format.json { render :show, status: :created, location: @complaint }
			else
				format.html { render :new }
				format.json { render json: @complaint.errors, status: :unprocessable_entity }
			end
		end
	end

	def destroy
		if(current_user == @complaint.user)
			@complaint.destroy
			respond_to do |format|
				format.html {redirect_to complaints_url, notice: "Complaint deleted successfully!"}
				format.json { head :no_content }
			end
		end
	end

	private

	def set_complaint
	  @complaint = Complaint.find(params[:id])
	end

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
