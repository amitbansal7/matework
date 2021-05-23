# frozen_string_literal: true

module V1
  module Open
    class Users < Grape::API
      namespace :users do
        params do
          requires :phone_number, type: String, allow_blank: false
        end
        post '/login' do
          # print(params[:phone_number])
          unless Phony.plausible?(params[:phone_number])
            return render_error(message: 'Invalid phone')
          end
          return render_success(message: 'Otp sent.')
        end

        params do
          requires :phone_number, type: String, allow_blank: false
          requires :otp, type: String, allow_blank: false
        end
        post '/verify' do
          return render_error(message: 'Invalid OTP') unless params[:otp] == '9711'

          user = User.find_or_initialize_by(phone_number: permitted_params[:phone_number])
          if user.persisted? || user.save
            render_success(
              message: 'Authenticated',
              data: { user: serialized_data(user, AuthUserSerializer), token: JwtService.create_new_token(user) }
            )
          else
            render_error(message: user.errors.full_messages.join(', '))
          end
        end
      end
    end
  end
end
