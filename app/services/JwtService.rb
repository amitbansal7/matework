# frozen_string_literal: true

class JwtService
  SECRET_KEY = 'aaasdfs'
  EXPIRY_TIME = 30.days
  REFRESH_TIME = 1.minute

  class << self
    def should_refresh?(token)
      decoded_token = decode_token(token)
      return if decoded_token.blank?

      (decoded_token[0]['exp'] - (EXPIRY_TIME.to_i - REFRESH_TIME.to_i)) < Time.current.to_i
    end

    def get_user(token)
      payload = decode_token(token)
      return if payload.blank?
      return if payload.dig(0, 'created_at') + EXPIRY_TIME.to_i <= Time.current.to_i

      User.find_by(phone_number: payload.dig(0, 'phone_number'))
    end

    def create_new_token(user)
      exp_payload = { phone_number: user.phone_number, created_at: Time.current.to_i, exp: EXPIRY_TIME.from_now.to_i }
      JWT.encode exp_payload, SECRET_KEY, 'HS256'
    end

    private

    def decode_token(token)
      JWT.decode token, SECRET_KEY, true, { algorithm: 'HS256' }
    rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
      nil
    end
  end
end
