# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module Schematics
  # :reek:Attribute
  class License
    include ::ActiveModel::API

    class << self
      def build(data)
        new JSON.parse(data || {})
      end
    end

    delegate :verify, to: :public_key, private: true
    attr_accessor :email, :expires_at, :signature

    def active?
      verify(digest, decoded_signature, payload) && !expired?
    end

    private

    def digest
      OpenSSL::Digest.new('SHA256')
    end

    def decoded_signature
      Base64.strict_decode64(signature.to_s)
    end

    def payload
      { email:, expires_at: }.to_json
    end

    def public_key
      OpenSSL::PKey::RSA.new(Rails.application.credentials.license.public_key)
    end

    def expired?
      return false unless expires_at

      expires_at < Time.current.to_i
    end
  end
end
