# frozen_string_literal: true

require 'jwt'
require 'active_support/core_ext/module/delegation'

class JsonWebToken
  class << self
    delegate :secret_key_base, to: 'Rails.application.secrets', private: true
    EXPIRES_IN = 24.hours.from_now.to_i

    def encode(payload)
      JWT.encode(payload.merge(exp: EXPIRES_IN), secret_key_base)
    end

    def decode(token)
      body, * = JWT.decode(token, secret_key_base)
      HashWithIndifferentAccess.new(body)
    rescue StandardError
      nil
    end
  end
end
