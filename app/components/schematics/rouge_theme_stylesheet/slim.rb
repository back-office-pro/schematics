# frozen_string_literal: true

Schematics::RougeThemeStylesheet::SLIM = <<~SLIM
  style [nonce=content_security_policy_nonce] = theme.render(scope:)
SLIM
