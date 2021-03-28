# frozen_string_literal: true

class InviteChannel < ApplicationCable::Channel
  def subscribed
    invite = current_user.invites.accepted.where(id: params[:id]).first
    if invite.present?
      stream_for invite
    else
      reject
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
