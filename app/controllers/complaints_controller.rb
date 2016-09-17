class ComplaintsController < ApplicationController
	before_action :set_complaint, only: [:show,:destroy]
	before_action :authenticate_user!

	def index
		if is_member?
			@ids = Member.find_by(username: current_user.username).categories
			if !@ids.nil?
				@ids = @ids.split(",")
				@complaints = Complaint.where('category_id = :ids OR user_id = :userid', ids: @ids, userid: current_user.id).order('created_at desc')
			end
		else
			@complaints = current_user.complaints.order('created_at desc').all
		end
		@username=session[:username]
		@notif = Notification.find_by_user(@username)
		if @notif != nil
			@lasttime = @notif.time
			@notif.time = DateTime.now
			@notif.save
		else
			@notif = Notification.new(:user=>@username)
			@notif.time=DateTime.now
			@notif.save
		end
	end

	def new
		@complaint =  Complaint.new
	end

	def show
		@complaint = Complaint.includes(:messages).find(params[:id])
		if is_relaventmember? or is_owner?
			@date = @complaint.messages.first.date
			@message = Message.new
		else
			respond_to do |format|
				format.html {redirect_to complaints_url, alert: "You are not authorized!"}
			end
		end
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
				@message = @complaint.messages.create!(body: @complaint.content, user_id: @complaint.user_id)
				@username=session[:username].downcase
				NotifMailer.notif(@username,@complaint.title,complaint_url(@complaint)).deliver_later
				@relaventmembers = Member.all
				@relaventmembers.each do |relmember|
				    @id = relmember.categories.split(",")
					@id.each do |catid|
					    if catid.to_i==@complaint.category_id
					    	NotifMailer.coordnotif(relmember.email,@complaint.title,complaint_url(@complaint)).deliver_later
					    end
					end
				end
				
				format.html { redirect_to @complaint, notice: "Complaint registered successfully!" }
				format.json { render :show, status: :created, location: @complaint }
			else
				format.html { render :new, error: "Something went wrong. Please try again." }
				format.json { render json: @complaint.errors, status: :unprocessable_entity }
			end
		end
	end

	def resolve
		@complaint = Complaint.find(params[:id])
		@complaint.solved = true
		if @complaint.save
			respond_to do |format|
				format.html {redirect_to complaints_url, notice: "Complaint Resolved!"}
			end
		else
			redirect_to @complaint
		end
	end

	def destroy
		if is_relaventmember? or is_owner?
			@complaint.destroy
			respond_to do |format|
				format.html {redirect_to complaints_url, notice: "Complaint deleted successfully!"}
				format.json { head :no_content }
			end
		end
	end

	def all
		@complaints = Complaint.order('created_at desc').all
	end
	
	private

	def set_complaint
	  @complaint = Complaint.find(params[:id])
	end

	def authenticate_user!
		unless logged_in?
		  store_location
		  redirect_to url_for(:controller=>'sessions',:action=>'new'), alert: "You need to sign in before continuing."
		end
	end

	def is_member?
		if Member.where(username: current_user.username).present?
			return true
		else
			return false
		end
	end

	def is_relaventmember?
		if Member.where(username: current_user.username).present?
			@ids = Member.find_by(username: current_user.username).categories
			if !@ids.nil?
				@ids = @ids.split(",")
				@ids.each do |value|
					@tempid = Complaint.find(params[:id]).category_id
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

	def is_owner?
		if current_user.id == @complaint.user_id
			return true
		else
			return false
		end
	end

	def complaint_params
	  params.require(:complaint).permit(:title, :content, :category_id, :attachment)
	end
end
