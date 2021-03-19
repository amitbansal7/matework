# frozen_string_literal: true

class Invite < ApplicationRecord
  acts_as_paranoid

  belongs_to :to_user, foreign_key: :to_user_id, class_name: 'User', validate: true
  belongs_to :from_user, foreign_key: :from_user_id, class_name: 'User', validate: true

  validates_presence_of :to_user, :from_user
  validates :to_user, presence: true, uniqueness: { scope: :from_user_id }
  validates :from_user, presence: true

  validate :cant_invite_self

  alias invited_by from_user
  alias invited to_user

  private

  def cant_invite_self
    errors.add(:base, 'User cannot invite itself') if to_user_id == from_user_id
  end


end
