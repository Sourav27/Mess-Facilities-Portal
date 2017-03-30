class SessionsController < ApplicationController
require 'net/ldap'
before_action :alreadyloggedin, only: [:new]

 def new
 end

 def create

    username = params[:session][:roll]
    password = params[:session][:password]
    if !username.match(/[a-zA-Z]{2}[0-9]{2}[a-zA-Z]{1}[0-9]{3}/)
    	@user = User.find_by(username: username)
       	k = @user.nil??false:@user.usertype == password
        if k  
        	sign_in @user
        	redirect_back_or root_url
        else
         	redirect_to login_path, alert:"Invalid username or password"
        
       end

     else
       ldap = Net::LDAP.new :host => "ldap.iitm.ac.in",
         :port => 389,
         :auth => {
           :method => :simple,
           :username => "cn=students,ou=bind,dc=ldap,dc=iitm,dc=ac,dc=in",
           :password => "rE11Bg_oO~iC"
         }

         if ldap.bind
           filter = Net::LDAP::Filter.eq("uid", username)
           treebase = "dc=ldap, dc=iitm, dc=ac, dc=in"
 
           ldap.search(:base => treebase, :filter => filter) do |entry|
             puts "DN: #{entry.dn}"
             if entry.dn
               ldap1 = Net::LDAP.new
               ldap1.host = "ldap.iitm.ac.in"
               ldap1.port = 389
               ldap1.auth entry.dn, password
               if ldap1.bind
                 @user = User.find_by(username: params[:session][:roll])
                 if @user
                   sign_in @user
                   redirect_back_or root_url
                  # flash[:success] = "Welcome, #{@user[:fullname]}"
                 else
                   redirect_to login_path, alert: "Sorry, such a user does not exist in our database."
                 end
               else
                 redirect_to login_path, alert: "Invalid username or password"
               end
             end
           end
         end
       end
  end

  def all
    @password = Digest::MD5.hexdigest(params[:session][:password])
    @admin = Admin.find_by(password_digest: @password)
    if @admin.present?  
      session[:admin] = @admin.id
      redirect_to complaints_all_url
    else
      redirect_to complaints_all_url, alert:"Invalid password"
    end
  end

  def destroy
    sign_out 
    redirect_to root_url
  end
  def alreadyloggedin
    if current_user.present?
	redirect_to root_url
    end
  end
end


