class UserSkill < ApplicationRecord
  belongs_to :user
  belongs_to :skill

  validates :rating, presence: true, inclusion: 1..5
  validates_uniqueness_of :skill_id, scope: :user_id

  delegate :name, to: :skill
end
