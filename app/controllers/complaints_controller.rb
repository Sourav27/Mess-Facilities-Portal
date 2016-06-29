class ComplaintsController < ApplicationController
	before_action :set_complaint, only: [:show,:destroy]
	before_action :authenticate_user!

	def index
		@complaints = current_user.complaints.order('created_at desc').all
	end

	def new
		@complaint =  Complaint.new
	end

	def show
		@complaint = Complaint.includes(:messages).find(params[:id])
		@message = Message.new
	end

	def create
		@complaint =  Complaint.new(complaint_params)
		@complaint.user_id = current_user.id
		if params[:complaint][:category]=='1'
			@complaint.category_id = params[:complaint][:mess_id]
		elsif params[:complaint][:category]=='2'
			@complaint.category_id = params[:complaint][:facility_id]
		end


		respond_to do |format|
			if @complaint.save
				format.html { redirect_to @complaint, notice: "Complaint registered successfully!" }
				format.json { render :show, status: :created, location: @complaint }
			else
				format.html { render :new, error: "Something went wrong. Please try again." }
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
	  params.require(:complaint).permit(:title, :content, :category_id, :attachment)
	end
end
