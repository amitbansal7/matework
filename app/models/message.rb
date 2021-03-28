# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :invite
  belongs_to :sender, class_name: 'User'

  validates_presence_of :text

  validate :sender_is_from_invite
  validate :invite_must_be_accepted

  after_create_commit :broadcast_to_channel

  private

  def invite_must_be_accepted
    errors.add(:invite, 'Invite must be accepted') unless invite.accepted
  end

  def sender_is_from_invite
    if (invite.from_user_id != sender_id) && (invite.to_user_id != sender_id)
      errors.add(:invite, 'Message must belong to the invite')
    end
  end

  def broadcast_to_channel
    InviteChannel.broadcast_to(
      invite,
      id: id,
      message: text,
      sender_id: sender_id,
      created_at: created_at.to_i
    )
  end
end
