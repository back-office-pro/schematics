# frozen_string_literal: true

module Application
  module ApiKey
    extend ActiveSupport::Concern

    prepended do
      scope :active, ActiveQuery
    end

    def active?
      return true unless expires_at

      ::Time.current.before?(expires_at)
    end

    def auth_token
      return unless super

      ::JsonWebToken.encode({ auth_token: super, exp: expires_at&.to_i }.compact)
    end

    def login!(*) = self

    def touch!(request)
      PaperTrail.request(enabled: false) do
        ::ApiRequest.create!(
          api_key: self,
          ip: request.ip,
          request_method: request.method,
          endpoint: request.original_fullpath
        )
      end
    end

    def user = Schematics::Api::User.new(permissions:)
  end
end
