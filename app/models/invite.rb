# frozen_string_literal: true

class Invite < ApplicationRecord
  acts_as_paranoid

  has_many :messages, dependent: :destroy

  belongs_to :to_user, foreign_key: :to_user_id, class_name: 'User', validate: true
  belongs_to :from_user, foreign_key: :from_user_id, class_name: 'User', validate: true

  validates :to_user, presence: true, uniqueness: { scope: :from_user_id }
  validates :from_user, presence: true

  validate :cant_invite_self
  after_create_commit :broacast_invite_created
  after_update :handle_invite_accepted, if: -> { previous_changes[:accepted] == [false, true] }

  alias invited_by from_user
  alias invited to_user

  scope :accepted, -> { where(accepted: true) }

  private

  def create_first_message
    return if messages.exists?

    messages.create!(text: message, sender_id: from_user_id, created_at: created_at)
  end

  def handle_invite_accepted
    [[to_user, from_user], [from_user, to_user]].each do |user|
      UserDataChannel.broadcast_to(
        user[0],
        type: 'invite_accepted',
        packet: {
          id: user[1].id,
          first_name: user[1].first_name,
          last_name: user[1].last_name,
          avatar: user[1].avatar,
          updated_at: self.updated_at.to_i,
          invite_id: self.id,
        }
      )
    end
    create_first_message
  end

  def broacast_invite_created
    UserDataChannel.broadcast_to(
      to_user,
      type: 'invite_created',
      packet: InviteSerializer.new(self).serializable_hash.dig(:data, :attributes)
    )
  end

  def cant_invite_self
    errors.add(:base, 'User cannot invite itself') if to_user_id == from_user_id
  end
end
