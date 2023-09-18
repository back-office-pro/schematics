# frozen_string_literal: true

Rails.configuration.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           Schematics::Engine.credentials.google_oauth2[:client_id],
           Schematics::Engine.credentials.google_oauth2[:client_secret],
           { prompt: 'select_account' }
  provider :saml,
           OneLogin::RubySaml::IdpMetadataParser
             .new
             .parse_remote_to_hash(Configuration.sso_metadata_url)
             .merge(
               sp_entity_id: Tenant.host,
               name_identifier_format: 'urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress',
               attribute_statements: { email: ['EmailAddress'] }
             )
end
