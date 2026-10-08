# frozen_string_literal: true

Schematics::InlineJavascript::SLIM = <<~SLIM
  javascript [nonce=content_security_policy_nonce]:
    window.environment = \#{environment}
    window.mapsAPIKey = \#{maps_api_key}
    window.I18n = \#{i18n}
    window.routes = \#{routes}
SLIM
