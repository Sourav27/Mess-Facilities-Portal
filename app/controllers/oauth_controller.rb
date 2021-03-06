class OauthController < ApplicationController
helper_method :get_token
helper_method :get_access_token 
helper_method :generate_token_req
helper_method :generate_auth_req
	def index
		#@posts = Post.where("solved=?",false).order('created_at DESC')
		@redirect_uri = request.original_url
		@auth_code = params[:authorization_code]
		if session[:access_token]
			@access_token = session[:access_token]
		else	
			@access_token=cookies[:remember_token]
			session[:access_token]=@access_token	
		end	

		if @access_token
			generate_access_req
     			get_user
     		if @user==nil
     			session[:access_token]=nil
     		else
   
     		@username=@user['username'].upcase
     		
     		session[:username]=@username
     		session[:user_id]=@user['id']
			@student=User.find_by_username(@user['username'])
     		# log_in @student
			redirect_back_or root_path
	     	
	        end
		elsif  @auth_code
			generate_token_req
      			get_token
      			session[:access_token] =@access_token
   				redirect_to  @redirect_uri


		else
			generate_auth_req
		      if($PRIVATE_SITE) 

		       redirect_to @auth_url
		      
		      else 
		        @signin_url = @auth_url
      		  end

		end


	
	end

	def signout
		session.delete(:access_token)
        session.delete(:user_id)
        self.current_user = nil
		redirect=request.original_url
		@redirect_uri=redirect.split('/logout')[0]
		#raise @redirect_uri[0].inspect
		#@redirect_uri=@redirect[0]
		
		@signout = $AUTH_SERVER +$CMD_SIGNOUT + "?response_type="+ $RESPONSE_TYPE +"&client_id=" +$CLIENT_ID +"&redirect_uri="+@redirect_uri +"&scope="+ $SCOPE +"&state=" +$STATE
		redirect_to @signout
	end





def generate_auth_req 
    	@auth_url = $AUTH_SERVER + $CMD_AUTHORIZE + "?response_type="+ $RESPONSE_TYPE +"&client_id=" + $CLIENT_ID + "&redirect_uri=" + @redirect_uri + "&scope="+ $SCOPE + "&state=" + $STATE
	end
  

  	def generate_token_req 
    	@token_url = $AUTH_SERVER + $CMD_REQUEST_TOKEN + "?client_id=" + $CLIENT_ID + "&client_secret=" + $CLIENT_SECRET + "&grant_type=" + @redirect_uri + "&authorization_code="+ @auth_code
	end
  

  	def generate_access_req 
    	@access_url = $AUTH_SERVER + $CMD_REQUEST_ACCESS + "?client_id=" + $CLIENT_ID + "&client_secret=" + $CLIENT_SECRET + "&access_token=" +@access_token
  	end

  	def get_token 
	   
	    require 'json'
		require 'open-uri'
		@file = JSON.parse open(@token_url).read
		@access_token=@file['access_token']
   
	end

  	def get_access_token 
    	@access_token = session[:access_token]
  	end

	def has_access_token 
	    if (@access_token) 
	      return true
	    else
	      return false
	  	end
	end	

    def has_auth_code 
    	if(@auth_code) 
      	 return true
    	else
      	return false
    	end	
  	end

 
  
	def get_user 
	  	require 'json'
		require 'open-uri'
		#raise  open(@access_url).read.inspect
		if(open(@access_url).read!='')
			@user = JSON.parse open(@access_url).read
			
		else
			session.delete(:access_token)
			cookies.delete :remember_token
			#raise generate_auth_req.inspect
			generate_auth_req
			redirect_to @auth_url
			#raise @auth_url.inspect
			#bhnijnjkn
		end

	end







end
