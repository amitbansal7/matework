# frozen_string_literal: true

module V1
  module Authenticated
    class Chats < Grape::API
      namespace :chats do
        params do
        end
        get '' do
          data = Invite.accepted
                       .where('from_user_id = ? OR to_user_id = ?', current_user.id, current_user.id)
                       .includes(:to_user, :from_user)
                       .order(:updated_at)
                       .map do |invite|
            user = invite.from_user_id == current_user.id ? invite.to_user : invite.from_user
            {
              id: user.id,
              first_name: user.first_name,
              last_name: user.last_name,
              avatar: user.avatar,
              updated_at: invite.updated_at.to_i,
              invite_id: invite.id
            }
          end

          render_success(
            data: {
              chats: data
            }
          )
        end
      end
    end
  end
end
