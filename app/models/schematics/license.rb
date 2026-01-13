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

    QUOTA = { USERS: 1, WEBHOOKS: 1, API_KEYS: 1, ROLES: 2, TEAMS: 2, STORAGE: 1.gigabyte }.freeze

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

    def storage_quota_will_be_exceeded?(size)
      return false if active?

      storage_size.bytes + size.bytes >= QUOTA[:STORAGE]
    end

    def users_quota_exceeded?
      return false if active?

      ::User.count >= QUOTA[:USERS]
    end

    def webhooks_quota_exceeded?
      return false if active?

      ::WebhookEndpoint.count >= QUOTA[:WEBHOOKS]
    end

    def api_keys_quota_exceeded?
      return false if active?

      ::APIKey.count >= QUOTA[:API_KEYS]
    end

    def roles_quota_exceeded?
      return false if active?

      ::Role.count >= QUOTA[:ROLES]
    end

    def teams_quota_exceeded?
      return false if active?

      ::Team.count >= QUOTA[:TEAMS]
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

    def valid_fingerprint? = Base64
      .strict_decode64(fingerprint.to_s)
      .eql?(secret_key_base)

    def public_key
      OpenSSL::PKey::RSA.new(Rails.application.credentials.license.public_key)
    end

    memoize def storage_size = ::ActiveStorage::Blob
      .with_deleted
      .sum(&:byte_size)
  end
end
