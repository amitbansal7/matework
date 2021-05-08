# frozen_string_literal: true

class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :first_name, :last_name, :id, :avatar

  attribute :short_bio do
    'Saas Product Manager'
  end
end
