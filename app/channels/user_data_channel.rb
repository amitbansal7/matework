# frozen_string_literal: true

class UserDataChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
  end

  def send_message(data)
    current_user.invites.find_by(id: data['invite_id'].to_i).messages.create!(
      text: data['message'],
      sender_id: current_user.id
    )
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
