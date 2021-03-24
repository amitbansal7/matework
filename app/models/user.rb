# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable,
  # :recoverable, :rememberable, :validatable

  phony_normalize :phone_number

  validates :phone_number, presence: true, uniqueness: true
  validates_plausible_phone :phone_number
  has_many :created_invites, class_name: 'Invite', foreign_key: :from_user_id
  has_many :received_invites, class_name: 'Invite', foreign_key: :to_user_id

  def connections
    connected_user_ids = created_invites.accepted.pluck(:to_user_id) + received_invites.accepted.pluck(:from_user_id)
    User.where(id: connected_user_ids)
  end
end
