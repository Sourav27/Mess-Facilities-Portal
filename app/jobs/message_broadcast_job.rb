class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(data, user)
  	message = Message.create!(body: data['message'], complaint_id: data['complaint_id'], user_id: user.id)
    ActionCable.server.broadcast "complaints_#{message.complaint_id}_channel", message: render_message(message), user_id: user.id
  end

  private

  def render_message(message)
  	MessagesController.render partial: 'messages/newmessage', locals: {message: message}
  end

end
