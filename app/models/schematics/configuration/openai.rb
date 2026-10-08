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
        return 'gpt-4o-2024-11-20' if chatgpt_access_token
        return 'gemini-2.5-flash' if gemini_access_token

        'deepseek-chat' if deepseek_access_token
      end
    end
  end
end
