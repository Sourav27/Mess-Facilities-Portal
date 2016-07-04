class Message < ApplicationRecord
  belongs_to :user
  belongs_to :complaint
  validates :body, presence: true, length: {minimum: 1, maximum: 1000}

  def timestamp
    created_at.strftime('%H:%M')
  end

  def date
  	created_at.strftime('%d %B %Y')
  end
end
