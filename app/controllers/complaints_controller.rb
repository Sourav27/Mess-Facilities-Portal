require 'securerandom'

class ComplaintsController < ApplicationController
	before_action :set_complaint, only: [:show,:destroy]
	before_action :authenticate_user!, except: [:all]

	def index
		@complaint =  Complaint.new

		if is_member?
			@ids = Member.find_by(username: current_user.username).categories
			if !@ids.nil?
				@ids = @ids.split(",")
				@complaints = Complaint.where(category_id: @ids).or(Complaint.where(user_id: current_user.username)).order('created_at desc')
			end
		else
			@complaints = Complaint.where(user_id: current_user.username).order('created_at desc').all
		end
		@username=current_user.username
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
		@complaint = Complaint.find(params[:id])
		@messages = Message.where(relation: @complaint.relation)
		if is_relaventmember? or is_owner?
			@date = @messages.first.date
			@message = Message.new
		else
			respond_to do |format|
				format.html {redirect_to complaints_url, alert: "You are not authorized!"}
			end
		end
	end

	def create
		@complaint =  Complaint.new(complaint_params)
		@complaint.user_id = current_user.username
		#raise @complaint.inspect
		#@complaint.valid?
		#@complaint.errors.full_messages
		@complaint.relation = SecureRandom.hex(5)
		if params[:complaint][:category_type]=='1'
			@complaint.category_id = params[:complaint][:mess_id]
		elsif params[:complaint][:category_type]=='2'
			@complaint.category_id = params[:complaint][:facility_id]
		end
		#@complaint.valid?
		# Rails.logger.debug("Category: #{@complaint.complaint_category_ids}")
            respond_to do |format|
			if @complaint.save
				@message = Message.create!(body: @complaint.content, user_id: @complaint.user_id, relation: @complaint.relation)
				@username=current_user.username.downcase
				NotifMailer.notif(current_user.fullname,@username,@complaint.title,@complaint.content,complaint_url(@complaint)).deliver_later
				@relaventmembers = Member.all
				@relaventmembers.each do |relmember|
				@membermails ||= []    
				@id = relmember.categories.split(",")
					@id.each do |catid|
					    if catid.to_i==@complaint.category_id
						@membermails << relmember.email
					    	#NotifMailer.coordnotif(relmember.name,relmember.email,@complaint.title,@complaint.content,complaint_url(@complaint)).deliver_later
					    end
					end
				end
				




					@caterer = Vendor.find_by(category_id: @complaint.category_id)
					@membermails << @caterer.email
					#Rails.logger.debug("Emails: #{@membermails}")
					NotifMailer.caterernotif(@caterer.name,@membermails,@complaint.title,@complaint.content,complaint_url(@complaint)).deliver_later

				
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
		@complaint.resolved_by = current_user.username
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
		#@month = params[:month]
		#@year = params[:year]
		@from = params[:from_date]
		@to = params[:to_date]
		@admin = session[:admin]
		# Rails.logger.debug("Month: #{@month}")
		# Rails.logger.debug("Year: #{@year}")
		# Rails.logger.debug("Admin: #{session[:admin]}")
		#if params[:month].present?
			#complaints1 = Complaint.where("MONTH(created_at) = ? and YEAR(created_at) = ?", @month,@year).order('created_at desc')
		if params[:from_date].present?
			complaints1 = Complaint.where(:created_at => @from.to_date.beginning_of_day..@to.to_date.end_of_day)
		else
			#@month = Date.today.month
			#@year = Date.today.year
			#complaints1 = Complaint.where("MONTH(created_at) = ? and YEAR(created_at) = ?", Date.today.month,Date.today.year).order('created_at desc')
			complaints1 = Complaint.where(:created_at => Time.now.beginning_of_day..Time.now.end_of_day)
		end	
		# Rails.logger.debug("complaint: #{complaints1.first.title}")
		@complaints ||= []
		if (1..2).include? @admin.to_i
			complaints1.each do |c|
				if c.category.type_id == @admin.to_i
					@complaints << c
					# Rails.logger.debug("cID: #{@complaints.id}")
				end
			end
			
		else
			@complaints = complaints1
		end
		
		respond_to do |format|
			format.html
			format.js
			format.xlsx{
    			response.headers['Content-Disposition'] = 'attachment; filename="complaints.xlsx"'
  			}
		end
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
					#Rails.logger.debug(value.to_i.inspect)
				    if value.to_i==@tempid
				    	return true 
				    #else
				    	#return false
				    end
				end
				return false
			else
				return false
			end

		else
			return false
		end
	end

	def is_owner?
		if current_user.username == @complaint.user_id
			return true
		else
			return false
		end
	end

	def complaint_params
		params.require(:complaint).permit(:title, :content, :category_id, :relation, :contacted, :complaint_category_ids, :category_type, :mess_id, :facility_id)
	end
end

