# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

require 'onelogin/ruby-saml'

describe OneLogin::RubySaml::Settings do
  it_behaves_like 'a monkey patched instance method',
                  :sp_entity_id,
                  '441918616d10bc354355dc1f1de687e5f427bc87712dc82a41412dbadee5c722'

  it_behaves_like 'a monkey patched instance method',
                  :idp_sso_service_url,
                  '3b09f4af57c355162cc410071abcf32935394e2d3d6c2a8d1f5b49ad6b5a6d59'

  it_behaves_like 'a monkey patched instance method',
                  :idp_cert_fingerprint,
                  'e74b0ec7f1aef1351ed90885ae2d6e0d8b977e3a72d4c0bf0a6dcced296a0c4f'
end
