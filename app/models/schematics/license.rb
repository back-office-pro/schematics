# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

# frozen_string_literal: true

module Schematics
  # :reek:Attribute
  class License
    include ::ActiveModel::API

    class << self
      def build(data)
        new JSON.parse(data || {})
      rescue JSON::ParserError
        new
      end
    end

    delegate :verify, to: :public_key, private: true
    delegate :secret_key_base, to: '::Rails.configuration', private: true

    attr_accessor :expires_at, :fingerprint, :signature

    def active?
      verify(digest, decoded_signature, payload) && !expired? && valid_fingerprint?
    end

    def as_json
      super.merge('server' => server) # rubocop:disable Style/StringHashKeys
    end

    private

    def digest
      OpenSSL::Digest.new('SHA256')
    end

    def decoded_signature
      Base64.strict_decode64(signature.to_s)
    end

    def payload
      { expires_at:, fingerprint: }.to_json
    end

    def expired?
      return false unless expires_at

      expires_at < Time.current.to_i
    end

    def valid_fingerprint?
      decoded_fingerprint == secret_key_base
    end

    def decoded_fingerprint
      Base64.strict_decode64(fingerprint.to_s)
    end

    def public_key
      OpenSSL::PKey::RSA.new(Rails.application.credentials.license.public_key)
    end

    def server = [`hostname`, MacAddress.address].join('|')
  end
end
