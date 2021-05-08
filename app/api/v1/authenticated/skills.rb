# frozen_string_literal: true

module V1
  module Authenticated
    class Skills < Grape::API
      namespace :skills do
        params do
        end
        get '' do
          user_skills = current_user.user_skills
          render_success(
            data: {
              skills: user_skills.map { |s| { name: s.name, rating: s.rating } }
            }
          )
        end
      end
    end
  end
end
