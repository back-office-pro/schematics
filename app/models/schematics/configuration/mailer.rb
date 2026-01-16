# Copyright © 2025 Dev & Software. All rights reserved.

# THIS SOFTWARE IS PROPRIETARY AND CONFIDENTIAL. UNAUTHORIZED COPYING, DISTRIBUTION, MODIFICATION,
# REVERSE ENGINEERING, OR DISCLOSURE IS STRICTLY PROHIBITED.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
# NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, AND
# NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES, OR OTHER
# LIABILITY ARISING FROM, OUT OF, OR IN CONNECTION WITH THE SOFTWARE OR ITS USE.

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
