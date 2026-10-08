# frozen_string_literal: true

module Schematics
  module Configuration
    class Mailer
      delegate :postmark_api_token,
               :mailgun_api_key,
               :mailjet_api_key,
               :mailjet_secret_key,
               to: :@configuration,
               private: true

      def initialize(configuration)
        @configuration = configuration
      end

      def configured?
        postmark_api_token || mailgun_api_key || (mailjet_api_key && mailjet_secret_key)
      end

      def delivery_method
        return :postmark if postmark_api_token
        return :mailgun if mailgun_api_key
        return :mailjet if mailjet_api_key && mailjet_secret_key

        Rails.configuration.action_mailer.delivery_method
      end

      def settings
        case delivery_method
        when :postmark
          { postmark_settings: { api_token: postmark_api_token } }
        when :mailgun
          { mailgun_settings: { api_key: mailgun_api_key, timeout: 5 } }
        when :mailjet
          { mailjet_settings: { api_key: mailjet_api_key, secret_key: mailjet_secret_key } }
        else
          {}
        end
      end
    end
  end
end
