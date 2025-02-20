# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

module OneLogin
  module Override
    module RubySaml
      module Settings
        def idp_sso_service_url
          super.try(:call) || super
        end

        def idp_cert_fingerprint
          super.try(:call) || super
        end
      end
    end
  end
end
