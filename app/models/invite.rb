# frozen_string_literal: true

class Invite < ApplicationRecord
  acts_as_paranoid

  has_many :messages, dependent: :destroy

  belongs_to :to_user, foreign_key: :to_user_id, class_name: 'User', validate: true
  belongs_to :from_user, foreign_key: :from_user_id, class_name: 'User', validate: true

  validates :to_user, presence: true, uniqueness: { scope: :from_user_id }
  validates :from_user, presence: true

  validate :cant_invite_self
  after_create_commit :broacast_message
  after_update_commit :create_first_message, if: -> { previous_changes[:accepted] == [false, true] }

  alias invited_by from_user
  alias invited to_user

  scope :accepted, -> { where(accepted: true) }

  private

  def create_first_message
    return if messages.present?

    messages.create!(text: message, sender_id: from_user_id, created_at: created_at, delivered: true)
  end

  def broacast_message
    UserDataChannel.broadcast_to(
      to_user,
      type: 'InviteCreated',
      invite_id: id,
      message: message,
      sender_id: from_user_id,
      created_at: created_at.to_i
    )
  end

  def cant_invite_self
    errors.add(:base, 'User cannot invite itself') if to_user_id == from_user_id
  end
end
