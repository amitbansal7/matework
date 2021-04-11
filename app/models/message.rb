# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :invite, touch: true
  belongs_to :sender, class_name: 'User'

  validates_presence_of :text, :sender_id

  validate :sender_is_from_invite
  validate :invite_must_be_accepted

  after_create_commit :broadcast_to_users

  attr_accessor :message_client_id

  def broadcast_to_user(user)
    UserDataChannel.broadcast_to(
      user,
      type: 'Message',
      invite_id: invite.id,
      message_client_id: message_client_id,
      id: id,
      message: text,
      sender_id: sender_id,
      created_at: created_at.to_i
    )
  end

  private

  def invite_must_be_accepted
    errors.add(:invite, 'Invite must be accepted') unless invite.accepted
  end

  def sender_is_from_invite
    if (invite.from_user_id != sender_id) && (invite.to_user_id != sender_id)
      errors.add(:invite, 'Message must belong to the invite')
    end
  end

  def broadcast_to_users
    [invite.from_user, invite.to_user].each do |user|
      broadcast_to_user(user)
    end
  end
end
