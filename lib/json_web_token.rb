# frozen_string_literal: true

require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/module/delegation'
require 'jwt'

class JsonWebToken
  class << self
    delegate :secret_key_base, to: 'Rails.application.secrets', private: true

    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, secret_key_base)
    end

    def decode(auth_token, *)
      body, * = JWT.decode(auth_token, secret_key_base)
      ActiveSupport::HashWithIndifferentAccess.new(body)
    rescue JWT::DecodeError
      { auth_token: }
    end
  end
end
