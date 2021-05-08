# frozen_string_literal: true

module V1
  module Authenticated
    class Base < Grape::API
      helpers V1::Helpers::Authentication
      helpers V1::Helpers::Utils

      before do
        authenticate!
      end

      mount V1::Authenticated::Users
      mount V1::Authenticated::Invites
      mount V1::Authenticated::Chats
      mount V1::Authenticated::Skills
      mount V1::Authenticated::UserProfiles
    end
  end
end
