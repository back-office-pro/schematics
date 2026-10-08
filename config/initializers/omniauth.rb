# frozen_string_literal: true

Rails.configuration.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           -> { Configuration.google_oauth_client_id },
           -> { Configuration.google_oauth_client_secret },
           { prompt: 'select_account' }
  provider :saml,
           sp_entity_id: -> { Configuration.company_name },
           idp_sso_service_url: -> { Configuration.sso_service_url },
           idp_cert_fingerprint: -> { Configuration.sso_cert_fingerprint },
           name_identifier_format: 'urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress',
           attribute_statements: { email: ['EmailAddress'] }
end
