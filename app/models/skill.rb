class Skill < ApplicationRecord
  has_many :user_skills, dependent: :destroy
end
