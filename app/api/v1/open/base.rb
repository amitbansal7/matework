# frozen_string_literal: true

module V1
  module Open
    class Base < Grape::API
      before do
        # deny_access unless V1::Services::SecretAuthenticator.valid?(headers)
      end

      namespace :o do
        mount V1::Open::Users
      end
    end
  end
end
