# frozen_string_literal: true

class UserProfileSerializer
  include FastJsonapi::ObjectSerializer
  attributes(
    :id, :first_name,
    :last_name, :avatar,
    :short_bio, :long_bio, :experience,
    :age, :external_link, :location, :looking_for
  )

  attribute :skills do |user|
    user.user_skills.order(rating: :desc).includes(:skill).map do |user_skill|
      {
        name: user_skill.skill.name,
        rating: user_skill.rating
      }
    end
  end
end
