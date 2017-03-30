# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class ComplaintsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "complaints_#{params['complaint_relation']}_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def send_message(data)
  	MessageBroadcastJob.perform_later(data, current_user)
  end
end
