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
    class OpenAI
      delegate :chatgpt_access_token,
               :gemini_access_token,
               :deepseek_access_token,
               to: :@configuration,
               private: true

      def initialize(configuration)
        @configuration = configuration
      end

      def configured?
        access_token.present?
      end

      def access_token
        chatgpt_access_token || gemini_access_token || deepseek_access_token
      end

      def uri_base
        return ::OpenAI::Configuration::DEFAULT_URI_BASE if chatgpt_access_token
        return 'https://generativelanguage.googleapis.com/v1beta/openai/' if gemini_access_token

        'https://api.deepseek.com/' if deepseek_access_token
      end

      def model
        return 'gpt-5.2-2025-12-11' if chatgpt_access_token
        return 'gemini-2.5-flash' if gemini_access_token

        'deepseek-chat' if deepseek_access_token
      end
    end
  end
end
