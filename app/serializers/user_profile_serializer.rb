# frozen_string_literal: true

class UserProfileSerializer
  include FastJsonapi::ObjectSerializer
  attributes :first_name, :last_name, :email, :phone_number, :avatar
end
