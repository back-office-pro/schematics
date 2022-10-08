# frozen_string_literal: true

require 'jwt'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/hash/indifferent_access'

class JsonWebToken
  class << self
    delegate :secret_key_base, to: 'Rails.application.secrets', private: true

    def encode(payload)
      JWT.encode(payload, secret_key_base)
    end

    def decode(token, *_args)
      body, * = JWT.decode(token, secret_key_base)
      ActiveSupport::HashWithIndifferentAccess.new(body)
    rescue JWT::DecodeError
      nil
    end
  end
end
