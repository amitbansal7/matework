# frozen_string_literal: true

class UserDataChannel < ApplicationCable::Channel
  after_subscribe :send_undelivered_messages

  def subscribed
    stream_for current_user
  end

  def send_message(data)
    current_user.invites.find_by(id: data['invite_id'].to_i).messages.create!(
      text: data['message'],
      sender_id: current_user.id,
      message_client_id: data['message_client_id']
    )
  end

  def message_received(data)
    current_user.messages
                .where.not(sender_id: current_user.id)
                .where(id: data['message_id'])
                .first.update!(delivered: true)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private

  def send_undelivered_messages
    current_user.messages
                .where.not(sender_id: current_user.id)
                .where(delivered: false).each do |message|
      message.send(:broadcast_to_user, current_user)
    end
  end
end
