# frozen_string_literal: true

Rails.configuration.content_security_policy do |policy|
  policy.default_src :self, :https
  policy.font_src :self, :https, :data
  policy.frame_src :self, :https, :blob
  policy.img_src :self, :https, :data
  policy.object_src :none
  policy.script_src :self, :https
  policy.style_src :self, :https, :unsafe_inline
end

Rails.configuration.content_security_policy_nonce_directives = %w[script-src]
Rails.configuration.content_security_policy_report_only = Rails.env.development?
Rails.configuration.content_security_policy_nonce_generator = lambda { |request|
  (request.env['HTTP_TURBO_REFERRER'].presence && request.env['HTTP_X_TURBO_NONCE']) ||
    SecureRandom.base64(16)
}
