# frozen_string_literal: true

class InviteSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :message

  attribute :created_at do |invite|
    invite.created_at.to_i
  end

  attribute :user do |invite|
    UserSerializer.new(invite.from_user).serializable_hash.dig(:data, :attributes)
  end
end
