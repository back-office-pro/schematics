# frozen_string_literal: true

module OneLogin
  module Override
    module RubySaml
      module Settings
        # :reek:FeatureEnvy :reek:ManualDispatch
        def idp_sso_service_url = super
          .then_tap { _1.call if _1.respond_to?(:call) }

        # :reek:FeatureEnvy :reek:ManualDispatch
        def idp_cert_fingerprint = super
          .then_tap { _1.call if _1.respond_to?(:call) }
      end
    end
  end
end
