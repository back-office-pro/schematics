# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

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
