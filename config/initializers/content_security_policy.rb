# frozen_string_literal: true

Rails.application.config.content_security_policy do |policy|
  policy.default_src :self, :https
  policy.font_src :self, :https, :data
  policy.img_src :self, :https, :data
  policy.object_src :none
  policy.script_src :self, :https
  policy.style_src :self, :https
end

Rails.application.config.content_security_policy_nonce_generator = ->(_) { SecureRandom.base64(16) }
Rails.application.config.content_security_policy_report_only = true
