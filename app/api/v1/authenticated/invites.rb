# frozen_string_literal: true

module V1
  module Authenticated
    class Invites < Grape::API
      namespace :invites do
        desc 'invite someone'
        params do
          requires :to_user_id, type: Integer
          optional :message, type: String
        end
        post '' do
          invite = current_user.created_invites.new(to_user_id: params[:to_user_id], message: params[:message])
          if invite.save
            render_success(
              message: 'Invitation Sent',
              data: nil
            )
          else
            render_error(message: invite.errors.full_messages.join(', '))
          end
        end

        params do
        end
        get '' do
          invites = current_user.received_invites.where(accepted: false).includes(:from_user)
          render_success(
            data: {
              invites: serialized_data(invites)
            }
          )
        end

        params do
          requires :invite_id, type: Integer
        end
        put 'accept' do
          invite = current_user.received_invites.where(accepted: false).find_by(id: params[:invite_id])
          if invite.present?
            if invite.update(accepted: true)
              render_success(
                message: 'Invitation accepted',
                data: nil
              )
            else
              render_error(message: invite.errors.full_messages.join(', '))
            end
          else
            render_error(message: 'Invite not found')
          end
        end

        params do
          requires :invite_id, type: Integer
        end
        delete '' do
          invite = current_user.received_invites.where(accepted: false).find_by(id: params[:invite_id])
          if invite.present?
            if invite.destroy
              render_success(
                message: 'Invitation deleted',
                data: nil
              )
            else
              render_error(message: invite.errors.full_messages.join(', '))
            end
          else
            render_error(message: 'Invite not found')
          end
        end
      end
    end
  end
end
