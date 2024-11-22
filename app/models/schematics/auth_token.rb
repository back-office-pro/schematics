# frozen_string_literal: true

module Schematics
  class AuthToken
    TOKEN_TYPE = 'Bearer'
    ACCESS_TOKEN_DURATION = 10.minutes.freeze
    REFRESH_TOKEN_DURATION = 1.day.freeze

    class << self
      def open_api_schema = {
        token_type: TOKEN_TYPE,
        expires_in: ACCESS_TOKEN_DURATION.to_i,
        access_token: String,
        refresh_token: String
      }
    end

    delegate :access_token, :refresh_token, to: :@session, private: true

    def initialize(session)
      @session = session
    end

    def as_json = {
      token_type: TOKEN_TYPE,
      expires_in: ACCESS_TOKEN_DURATION.to_i,
      access_token:,
      refresh_token:
    }
  end
end
