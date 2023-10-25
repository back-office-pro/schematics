# frozen_string_literal: true

require 'jwt'

module JWT
  module AuthToken
    module_function

    def encode(auth_token, exp = 1.hour.from_now.to_i)
      module_parent.encode({ auth_token:, exp: }, secret)
    end

    def decode(auth_token, *)
      module_parent.decode(auth_token, secret)[0]['auth_token']
    rescue JWT::DecodeError
      nil
    end

    def secret = Rails
      .application
      .credentials
      .secret_key_base
  end
end
