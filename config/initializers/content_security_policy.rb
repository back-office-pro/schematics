# frozen_string_literal: true

Rails.configuration.content_security_policy do |policy|
  policy.default_src :self, :https
  policy.font_src :self, :https, :data
  policy.img_src :self, :https, :data
  policy.object_src :none
  policy.script_src :self, :https
  policy.style_src :self, :https, :unsafe_inline
end

Rails.configuration.content_security_policy_nonce_directives = %w[script-src]
Rails.configuration.content_security_policy_report_only = Rails.env.development?
Rails.configuration.content_security_policy_nonce_generator = lambda { |request|
  return request.env['HTTP_X_TURBOLINKS_NONCE'] if request.env['HTTP_TURBOLINKS_REFERRER'].present?

  SecureRandom.base64(16)
}
