# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  class License
    delegate :public_key, to: 'Rails.application.credentials.license', private: true
    delegate :license_key, to: '::Configuration', private: true

    def valid?
      OpenSSL::PKey::RSA.new(public_key).verify(
        OpenSSL::Digest.new('SHA256'),
        license_key,
        payload
      )
    end
  end
end
