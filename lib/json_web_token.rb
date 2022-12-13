# frozen_string_literal: true

require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/module/delegation'
require 'jwt'

class JsonWebToken
  class << self
    delegate :secret_key_base, to: 'Rails.application.secrets', private: true

    def encode(auth_token:, exp: 24.hours.from_now.to_i)
      JWT.encode({ auth_token:, exp: }, secret_key_base)
    end

    def decode(token, *)
      JWT
        .decode(token, secret_key_base)
        .first
        .fetch('auth_token')
    rescue JWT::DecodeError
      token
    end
  end
end
