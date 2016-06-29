class Message < ApplicationRecord
  belongs_to :user
  belongs_to :complaint
  validates :body, presence: true, length: {minimum: 1, maximum: 1000}

  def timestamp
    created_at.strftime('%H:%M:%S %d %B %Y')
  end
end
