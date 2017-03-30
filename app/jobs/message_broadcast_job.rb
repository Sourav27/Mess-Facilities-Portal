class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(data, user)
  	date = Message.where(relation: data['complaint_relation']).last.date
  	message = Message.create!(body: data['message'], relation: data['complaint_relation'], user_id: user.username)
    ActionCable.server.broadcast "complaints_#{message.relation}_channel", message: render_message(message,date), user_id: user.username
  end

  private

  def render_message(message,date)
  	MessagesController.render partial: 'messages/newmessage', locals: {message: message, date: date}
  end

end

