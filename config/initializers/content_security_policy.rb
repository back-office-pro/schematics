# Copyright © 2025 Dev & Software. All rights reserved.
# frozen_string_literal: true

Rails.configuration.content_security_policy do |policy|
  policy.default_src :self, :https
  policy.font_src :self, :https, :data
  policy.frame_src :self, :https
  policy.img_src :self, :https, :data
  policy.object_src :none
  policy.script_src :self, :https, :strict_dynamic
  policy.style_src :self, :https, :unsafe_inline
  policy.connect_src :self, :https, :wss
end

Rails.configuration.content_security_policy_nonce_directives = %w[script-src]
Rails.configuration.content_security_policy_report_only = Rails.env.development?
Rails.configuration.content_security_policy_nonce_generator = -> { _1.session.id.to_s }
