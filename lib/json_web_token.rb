class JsonWebToken
  class << self
    delegate :secret_key_base, to: 'Rails.application.secrets', private: true

    def encode(payload, exp: 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, secret_key_base)
    end

    def decode(token)
      body, * = JWT.decode(token, secret_key_base)
      HashWithIndifferentAccess.new(body)
    rescue StandardError
      nil
    end
  end
end
