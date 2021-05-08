# frozen_string_literal: true

module V1
  module Authenticated
    class Users < Grape::API
      namespace :users do
        desc 'auth'
        params do
        end
        get 'auth' do
          if current_user.present?
            render_success(
              message: 'Authenticated',
              data: {
                user: serialized_data(current_user, AuthUserSerializer),
                token: JwtService.should_refresh?(auth_token) ? JwtService.create_new_token(current_user) : auth_token
              }
            )
          else
            render_error(message: 'Not authenticated')
          end
        end

        desc 'update profile'
        params do
          requires :email, type: String, allow_blank: false
          requires :name, type: String, allow_blank: true
          requires :username, type: String, allow_blank: false
          requires :phone_number, type: String, allow_blank: true
        end
        put '/update' do
          if current_user.update(permitted_params)
            render_success(message: 'User Updated', data: serialized_data(current_user))
          else
            render_error(message: current_user.errors.full_messages.join(', '))
          end
        end

        desc 'update password'
        params do
          optional :password, type: String, allow_blank: false
          optional :new_password, type: String, allow_blank: false
        end
        put '/update_pass' do
          if !current_user.valid_password?(permitted_params[:password])
            render_error(message: 'Invalid password')
          elsif current_user.update(password: params[:new_password])
            render_success(message: 'Password Updated', data: serialized_data(current_user, AuthUserSerializer))
          else
            render_error(message: current_user.errors.full_messages.join(', '))
          end
        end
      end
    end
  end
end
