class User < ApplicationRecord
	establish_connection :students_1617
	has_many :complaints, dependent: :destroy
	has_many :messages, dependent: :destroy
	def User.new_remember_token
    	SecureRandom.urlsafe_base64
  	end

  	def User.digest(token)
    	Digest::SHA1.hexdigest(token.to_s)
  	end

	private

  	def create_remember_token
    		self.remember_token = User.digest(User.new_remember_token)
  	end
end
