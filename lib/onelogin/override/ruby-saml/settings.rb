# frozen_string_literal: true

module OneLogin
  module Override
    module RubySaml
      module Settings
        def idp_sso_service_url = super
          .then_tap { _1.call if _1.respond_to?(:call) }

        def idp_cert_fingerprint = super
          .then_tap { _1.call if _1.respond_to?(:call) }
      end
    end
  end
end
