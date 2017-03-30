class Message < ApplicationRecord
  validates :body, presence: true, length: {minimum: 1, maximum: 1000}
  
  def timestamp
    (created_at+0.minutes).strftime('%H:%M')
  end

  def date
  	(created_at+0.minutes).strftime('%d %B %Y')
  end
end
