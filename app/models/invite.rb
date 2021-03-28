# frozen_string_literal: true

class Invite < ApplicationRecord
  acts_as_paranoid

  has_many :messages, dependent: :destroy

  belongs_to :to_user, foreign_key: :to_user_id, class_name: 'User', validate: true
  belongs_to :from_user, foreign_key: :from_user_id, class_name: 'User', validate: true

  validates :to_user, presence: true, uniqueness: { scope: :from_user_id }
  validates :from_user, presence: true

  validate :cant_invite_self

  alias invited_by from_user
  alias invited to_user

  scope :accepted, -> { where(accepted: true) }

  private

  def cant_invite_self
    errors.add(:base, 'User cannot invite itself') if to_user_id == from_user_id
  end
end
