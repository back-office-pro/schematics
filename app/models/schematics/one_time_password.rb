# frozen_string_literal: true

module Schematics
  class OneTimePassword
    include ::ActiveModel::API
    include ::ActiveModel::Attributes
    TOKEN_DURATION = 30

    attribute :user
    attribute :attempt
    attribute :secret, default: -> { ::ROTP::Base32.random }

    memoize def qr_code = ::RQRCode::QRCode.new(provisioning_uri)

    def verify
      totp.verify(attempt, drift_behind: TOKEN_DURATION)
    end

    private

    memoize def totp = ::ROTP::TOTP.new(secret, issuer:)

    def issuer = ::Configuration.company_name

    def provisioning_uri
      totp.provisioning_uri(user.email)
    end
  end
end
