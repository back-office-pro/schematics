# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

Rails.configuration.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           Rails.application.credentials.google_oauth2.client_id,
           Rails.application.credentials.google_oauth2.client_secret,
           { prompt: 'select_account' }
  provider :saml,
           sp_entity_id: -> { Configuration.company_website },
           idp_sso_service_url: -> { Configuration.sso_service_url },
           idp_cert_fingerprint: -> { Configuration.sso_cert_fingerprint },
           name_identifier_format: 'urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress',
           attribute_statements: { email: ['EmailAddress'] }
end
