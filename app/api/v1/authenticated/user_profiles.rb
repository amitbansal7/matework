# frozen_string_literal: true

module V1
  module Authenticated
    class UserProfiles < Grape::API
      helpers V1::Helpers::Utils

      namespace :profiles do
        get ':id' do
          user = User.includes(user_skills: :skill).find(params[:id])
          if user.present?
            render_success(
              data: {
                profile: serialized_data(
                  User.find(params[:id]),
                  UserProfileSerializer
                )
              }
            )
          else
            render_error(message: 'Profile not found')
          end
        end

        params do
          use :pagination
        end
        get '' do
          users = User.all.order(:created_at).page(params[:page]).per_page(params[:per_page])
          users = users.includes(user_skills: :skill)
          render_success(
            data: serialized_data(
              users,
              UserProfileSerializer
            )
          )
        end
      end
    end
  end
end
